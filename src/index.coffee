_ = require 'underscore'
Hoek = require "hoek"
mongoose = require 'mongoose'
Boom = require 'boom'

mongooseIdentityStore = require 'mongoose-identity-store-multi-tenant'

Mixed = mongoose.Schema.Types.Mixed
ObjectId = mongoose.Schema.Types.ObjectId

module.exports.register = (plugin, options = {}, cb) ->
  defaults =
    mongodbUrl: null
    autoIndex: false
    needConnection: false 

  options = Hoek.applyToDefaults defaults, options

  ###
  This is just a dummy here and ignored.
  ###
  oauthProvider = 
        "authorizeUrl": "/oauth/authorize"
        "accessTokenUrl": "/oauth/token"
        "scopes": [
          {"name": "read", "description": "Allows read access to your data.", "developerDescription": "", "roles": ["public"]},
          {"name": "write", "description": "Allows write access to your data.", "developerDescription": "", "roles": ["public"]},
          {"name": "email", "description": "Allows access to your email address.", "developerDescription": "", "roles": ["public"]},
          {"name": "admin", "description": "Allows full admin access to the platform.", "developerDescription": "", "roles": ["admin"]}
        ]
  identityStore = mongooseIdentityStore.store 
                        oauthProvider : oauthProvider
                        autoIndex : options.autoIndex

  methods = {}

  for n in [
        'users'
        'organizations'
        'entities'
        'oauthScopes'
        'oauthApps'
        'oauthAuth'
        'admin'
        'roles'
      ]
    #onsole.log "Exporting methods #{n}"
    methods[n] = identityStore[n]

  models = {}
  for n,v of identityStore.models
    #console.log "Exporting model #{n}"
    models[n] = v 


  plugin.expose 'identityStore', identityStore
  plugin.expose 'methods', methods
  plugin.expose 'models', models

  cb()

module.exports.register.attributes =
    pkg: require '../package.json'
