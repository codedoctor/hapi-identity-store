assert = require 'assert'
should = require 'should'
index = require '../lib/index'
_ = require 'underscore'

loadServer = require './support/load-server'

describe 'WHEN index has been loaded', ->
  it 'it should expose a HAPI interface', (cb) ->

    should.exist index
    index.should.have.property "register"
    index.register.should.have.property "attributes"

    cb null

  it 'it should load the plugin', (cb) ->
    loadServer (err,server) ->
      return cb err if err

      should.exist server
      server.should.have.property "pack"

      myPlugin = server.pack.plugins['hapi-identity-store']
      should.exist myPlugin
      myPlugin.should.have.property "identityStore"
      myPlugin.should.have.property "models"
      myPlugin.should.have.property "methods"


      cb null
