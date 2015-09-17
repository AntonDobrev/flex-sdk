should = require 'should'
moment = require 'moment'
kinveyDate = require '../../../lib/service/modules/kinveyDate'

describe 'date string conversion', () ->
  describe 'to Kinvey (ISO) date string', () ->
    it 'returns null if no parameter is passed in', (done) ->
      should.not.exist kinveyDate.toKinveyDateString()
      done()

    it 'returns null if parameter is not a string, a Date, or a Moment', (done) ->
      should.not.exist kinveyDate.toKinveyDateString 1
      should.not.exist kinveyDate.toKinveyDateString true
      should.not.exist kinveyDate.toKinveyDateString {}
      should.not.exist kinveyDate.toKinveyDateString []
      should.not.exist kinveyDate.toKinveyDateString null
      done()

    it 'returns null if parameter is an invalid Moment', (done) ->
      should.not.exist kinveyDate.toKinveyDateString moment(new Date('abc'))
      done()

    it 'returns the original string if it is already a Mongo ISODate string', (done) ->
      isoDateString = 'ISODate("' + new Date().toISOString() + '")'
      kinveyDate.toKinveyDateString(isoDateString).should.eql isoDateString
      done()

    it "returns 'Invalid date' if the incoming string is not parsable by Moment", (done) ->
      kinveyDate.toKinveyDateString("not a date").should.eql 'Invalid date'
      done()

    it 'returns a correct Mongo ISODate string when a valid date string is passed in', (done) ->
      date = new Date()
      kinveyDate.toKinveyDateString(date.toISOString()).should.eql 'ISODate("' + date.toISOString() + '")'
      done()

    it 'returns a correct Mongo ISODate string when a valid date object is passed in', (done) ->
      date = new Date()
      kinveyDate.toKinveyDateString(date).should.eql 'ISODate("' + date.toISOString() + '")'
      done()

    it 'returns a correct Mongo ISODate string when a valid Moment is passed in', (done) ->
      date = new Date()
      kinveyDate.toKinveyDateString(moment(date)).should.eql 'ISODate("' + date.toISOString() + '")'
      done()

  describe 'from Kinvey (ISO) date string', () ->
    it "returns 'Invalid date' if no parameter is passed in", (done) ->
      kinveyDate.fromKinveyDateString().should.eql 'Invalid date'
      done()

    it "returns 'Invalid date' if a non Mongo ISODate string is passed in", (done) ->
      kinveyDate.fromKinveyDateString('abcd').should.eql 'Invalid date'
      kinveyDate.fromKinveyDateString(new Date().toISOString()).should.eql 'Invalid date'
      kinveyDate.fromKinveyDateString({}).should.eql 'Invalid date'
      done()

    it 'throws an error if the Mongo ISODate string contains an invalid date', (done) ->
      dateString = new Date().toISOString()
      kinveyDate.fromKinveyDateString('ISODate("').should.throw()
      kinveyDate.fromKinveyDateString('ISODate("abc').should.throw()
      done()

    it 'defaults to returning a Date if no format is specified', (done) ->
      dateString = new Date().toISOString()
      convertedDate = kinveyDate.fromKinveyDateString('ISODate("' + dateString + '")')
      Object::toString.call(convertedDate).should.eql '[object Date]'
      convertedDate.toISOString().should.eql dateString
      done()

    it "returns 'Invalid Format.' if format is not 'string', 'date', 'moment' or undefined", (done) ->
      dateString = new Date().toISOString()
      kinveyDate.fromKinveyDateString('ISODate("' + dateString + '")', 'invalid').should.eql 'Invalid Format.'
      done()

    it "returns a Date if format is 'date'", (done) ->
      dateString = new Date().toISOString()
      convertedDate = kinveyDate.fromKinveyDateString('ISODate("' + dateString + '")', 'date')
      Object::toString.call(convertedDate).should.eql '[object Date]'
      convertedDate.toISOString().should.eql dateString
      done()

    it "returns a string if format is 'string'", (done) ->
      dateString = new Date().toISOString()
      convertedDate = kinveyDate.fromKinveyDateString('ISODate("' + dateString + '")', 'string')
      'string'.should.eql typeof convertedDate
      convertedDate.should.eql dateString
      done()

    it "returns a Moment if format is 'moment'", (done) ->
      dateString = new Date().toISOString()
      convertedDate = kinveyDate.fromKinveyDateString('ISODate("' + dateString + '")', 'moment')
      moment.isMoment(convertedDate).should.be.true
      convertedDate.isValid().should.be.true
      convertedDate.toISOString().should.eql dateString
      done()