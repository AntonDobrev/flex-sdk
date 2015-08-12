# Copyright (c) 2015, Kinvey, Inc. All rights reserved.
#
# This software is licensed to you under the Kinvey terms of service located at
# http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
# software, you hereby accept such terms of service  (and any agreement referenced
# therein) and agree that you have read, understand and agree to be bound by such
# terms of service and are of legal age to agree to such terms with Kinvey.
#
# This software contains valuable confidential and proprietary information of
# KINVEY, INC and is subject to applicable licensing agreements.
# Unauthorized reproduction, transmission or distribution of this file and its
# contents is a violation of applicable laws.

util = require 'util'
receiver = require 'code-task-receiver'

module.exports = do ->

  class Service
    constructor: (@task, callback) ->

      @dataLink = require './service/datalink'
      @businessLogic = require './service/businesslogic'
      @modules = require('./service/modules')(@task)

      taskReceivedCallback = (task, completionCallback) ->
        if task.taskType is 'dataLink'
          @data.process task, completionCallback
        else if task.taskType is 'businessLogic'
          @businessLogic.process task, completionCallback

      receiver.start taskReceivedCallback, (err, result) ->
        return callback new Err "Could not start task receiver: #{err}"
        callback()


  generateService = (task, callback) ->
    return new Service(task, callback)

  obj =
    service: generateService

  return obj