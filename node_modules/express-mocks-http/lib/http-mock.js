/**
 * Module: http-mock
 *
 *   The interface for this entire module that just exposes the exported
 *   functions from the other libraries.
 */

var request  = require('./mockRequest');
var response = require('./mockResponse');
var xresponse = require('./mockExpressResponse');
var xrequest = require('./mockExpressRequest');

exports.createRequest = request.createRequest;
exports.createResponse= response.createResponse;
exports.createExpressResponse= xresponse.createExpressResponse;
exports.createExpressRequest= xrequest.createExpressRequest;