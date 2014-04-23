var http = require('http')
  , parse = require('url').parse
  , mime = require('mime');


/**
 * File: mockRequest
 *
 * This file implements node.js's implementation of a 'request' object.
 * This is actually closer to what Express offers the user, in that the
 * body is really a parsed object of values.
 *
 * @author Howard Abrams <howard.abrams@gmail.com>
 */

/**
 * Function: createRequest
 *
 *    Creates a new mock 'request' instance. All values are reset to the
 *    defaults.
 *
 * Parameters:
 *
 *   options - An object of named parameters.
 *
 * Options:
 *
 *   method - The method value, see <mockRequest._setMethod>
 *   url    - The url value, see <mockRequest._setURL>
 *   params - The parameters, see <mockRequest._setParam>
 *   body   - The body values, , see <mockRequest._setBody>
 */

exports.createExpressRequest = function(options) {
    if (!options) {
        options = {};
    }

    if (options.headers) {
        headers = {};
        for (h in options.headers) {
          headers[h.toLowerCase()] = options.headers[h];
        }
        options.headers = headers
    }

    return {
        method : (options.method) ? options.method : 'GET',
        headers: (options.headers) ? options.headers : {},
        url    : (options.url   ) ? options.url    : '',
        params : (options.params) ? options.params : {},
        session: (options.session) ? options.session : {},
        body   : (options.body  ) ? options.body   : {},
        query  : (options.query ) ? options.query  : {},
        files  : (options.files ) ? options.files  : {},



    /**
     * Return request header or optional default.
     *
     * The `Referrer` header field is special-cased,
     * both `Referrer` and `Referer` will yield are
     * interchangeable.
     *
     * Examples:
     *
     *     req.header('Content-Type');
     *     // => "text/plain"
     *
     *     req.header('content-type');
     *     // => "text/plain"
     *
     *     req.header('Accept');
     *     // => undefined
     *
     *     req.header('Accept', 'text/html');
     *     // => "text/html"
     *
     * @param {String} name
     * @param {String} defaultValue
     * @return {String}
     * @api public
     */

    header: function(name, defaultValue){
      switch (name = name.toLowerCase()) {
        case 'referer':
        case 'referrer':
          return this.headers.referrer
            || this.headers.referer
            || defaultValue;
        default:
          return this.headers[name] || defaultValue;
      }
    },

    /**
     * Get `field`'s `param` value, defaulting to ''.
     *
     * Examples:
     *
     *     req.get('content-disposition', 'filename');
     *     // => "something.png"
     *
     * @param {String} field
     * @param {String} param
     * @return {String}
     * @api public
     */

    get: function(field, param){
      var val = this.header(field);
      if (!val) return '';
      var regexp = new RegExp(param + ' *= *(?:"([^"]+)"|([^;]+))', 'i');
      if (!regexp.exec(val)) return '';
      return RegExp.$1 || RegExp.$2;
    },



    /**
     * Check if the _Accept_ header is present, and includes the given `type`.
     *
     * When the _Accept_ header is not present `true` is returned. Otherwise
     * the given `type` is matched by an exact match, and then subtypes. You
     * may pass the subtype such as "html" which is then converted internally
     * to "text/html" using the mime lookup table.
     *
     * Examples:
     *
     *     // Accept: text/html
     *     req.accepts('html');
     *     // => true
     *
     *     // Accept: text/*; application/json
     *     req.accepts('html');
     *     req.accepts('text/html');
     *     req.accepts('text/plain');
     *     req.accepts('application/json');
     *     // => true
     *
     *     req.accepts('image/png');
     *     req.accepts('png');
     *     // => false
     *
     * @param {String} type
     * @return {Boolean}
     * @api public
     */

    accepts: function(type){
      var accept = this.header('Accept');

      // normalize extensions ".json" -> "json"
      if (type && '.' == type[0]) type = type.substr(1);

      // when Accept does not exist, or is '*/*' return true
      if (!accept || '*/*' == accept) {
        return true;
      } else if (type) {
        // allow "html" vs "text/html" etc
        if (!~type.indexOf('/')) type = mime.lookup(type);

        // check if we have a direct match
        if (~accept.indexOf(type)) return true;

        // check if we have type/*
        type = type.split('/')[0] + '/*';
        return !!~accept.indexOf(type);
      } else {
        return false;
      }
    },

    /**
     * Return the value of param `name` when present or `defaultValue`.
     *
     *  - Checks route placeholders, ex: _/user/:id_
     *  - Checks query string params, ex: ?id=12
     *  - Checks urlencoded body params, ex: id=12
     *
     * To utilize urlencoded request bodies, `req.body`
     * should be an object. This can be done by using
     * the `connect.bodyParser` middleware.
     *
     * @param {String} name
     * @param {Mixed} defaultValue
     * @return {String}
     * @api public
     */

    param: function(name, defaultValue){
      // route params like /user/:id
      if (this.params && this.params.hasOwnProperty(name) && undefined !== this.params[name]) {
        return this.params[name];
      }
      // query string params
      if (undefined !== this.query[name]) {
        return this.query[name];
      }
      // request body params via connect.bodyParser
      if (this.body && undefined !== this.body[name]) {
        return this.body[name];
      }
      return defaultValue;
    },

        /**
         * Function: _setParameter
         *
         *    Set parameters that the client can then get using the 'params'
         *    key.
         *
         * Parameters:
         *
         *   key - The key. For instance, 'bob' would be accessed: request.params.bob
         *   value - The value to return when accessed.
         */

        _setParameter: function( key, value ) {
            this.params[key] = value;
        },

        /**
         * Sets a variable that is stored in the session.
         *
         * @param variable The variable to store in the session
         * @param value    The value associated with the variable
         */
        _setSessionVariable: function( variable, value ) {
            this.session[variable] = value;
        },

        /**
         * Sets a variable that is stored in the files.
         *
         * @param variable The variable to store in the session
         * @param value    The value associated with the variable
         */
        _setFilesVariable: function( variable, value ) {
            this.files[variable] = value;
        },

        /**
         * Function: _setMethod
         *
         *    Sets the HTTP method that the client gets when the called the 'method'
         *    property. This defaults to 'GET' if it is not set.
         *
         * Parameters:
         *
         *   method - The HTTP method, e.g. GET, POST, PUT, DELETE, etc.
         *
         * Note: We don't validate the string. We just return it.
         */

        _setMethod: function( method ) {
            this.method  = method;
        },

        /**
         * Function: _setURL
         *
         *    Sets the URL value that the client gets when the called the 'url'
         *    property.
         *
         * Parameters:
         *
         *   url - The request path, e.g. /my-route/452
         *
         * Note: We don't validate the string. We just return it. Typically, these
         * do not include hostname, port or that part of the URL.
         */

        _setURL: function( url ) {
            this.url = url;
        },

        /**
         * Function: _setBody
         *
         *    Sets the body that the client gets when the called the 'body'
         *    parameter. This defaults to 'GET' if it is not set.
         *
         * Parameters:
         *
         *   body - An object representing the body.
         *
         * If you expect the 'body' to come from a form, this typically means that
         * it would be a flat object of properties and values, as in:
         *
         * > {  name: 'Howard Abrams',
         * >    age: 522
         * > }
         *
         * If the client is expecting a JSON object through a REST interface, then
         * this object could be anything.
         */

        _setBody: function( body ) {
            this.body = body;
        },

        /**
         * Function: _addBody
         *
         *    Adds another body parameter the client gets when calling the 'body'
         *    parameter with another property value, e.g. the name of a form element
         *    that was passed in.
         *
         * Parameters:
         *
         *   key - The key. For instance, 'bob' would be accessed: request.params.bob
         *   value - The value to return when accessed.
         */

        _addBody: function( key, value ) {
            this.body[key] = value;
        }
    };
};

