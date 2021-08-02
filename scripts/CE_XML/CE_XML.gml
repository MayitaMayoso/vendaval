/*
	XML Parser by kraifpatrik
	https://github.com/kraifpatrik/CE/blob/master/scripts/ce_xml/ce_xml.gml
*/

/// @enum XML delimiters.
/// @private
enum CE_EXmlChars
{
	/// @member Null character.
	Null = 0,
	/// @member Line feed.
	LF = 10,
	/// @member Carriage return.
	CR = 13,
	/// @member Space.
	Space = 32,
	/// @member Exclamation mark.
	EM = 33,
	/// @member Double quote.
	DQ = 34,
	/// @member Single quote.
	SQ = 39,
	/// @member Slash.
	Slash = 47,
	/// @member Less-than sign.
	LT = 60,
	/// @member Equals sign.
	Equal = 61,
	/// @member Greater-than sign.
	GT = 62,
	/// @member Question mark.
	QM = 63
};

/// @func CE_XmlError([_msg])
/// @desc Base class for all errors thrown by the XML library.
/// @param {string} [_msg] An error message. Defaults to an empty string.
function CE_XmlError() constructor
{
	/// @var {string} The error message.
	/// @readonly
	msg = (argument_count > 0) ? argument[0] : "";
};

/// @func CE_XmlElement([_name[, value]])
/// @desc Represents a tag within an XML document.
/// @param {string} [_name] The name of the element. Defaults to an empty string.
/// @param {string/real/bool/undefined} [_value] The element value. Defaults to
/// `undefined`.
function CE_XmlElement() constructor
{
	/// @var {string} The name of the element.
	/// @readonly
	name = (argument_count > 0) ? argument[0] : "";

	/// @var {string/real/bool/undefined} The element's value. If `undefined`,
	/// then the element does not have a value.
	/// @readonly
	value = (argument_count > 1) ? argument[1] : undefined;

	/// @var {ds_map<string, string/real/bool>} A map of element's attributes.
	/// @readonly
	attributes = ds_map_create();

	/// @var {CE_XmlElement/undefined} The parent of this element. If `undefined`,
	/// then this is a root element.
	/// @readonly
	parent = undefined;

	/// @var {ds_list<CE_XmlElement>} A list of child elements.
	/// @readonly
	children = ds_list_create();

	/// @func set_attribute(_name, _value)
	/// @param {string} _name The name of the attribute.
	/// @param {string/real/bool/undefined} _value The attribute value.
	/// @return {CE_XmlElement} Returns `self` to allow method chaining.
	static set_attribute = function (_name, _value) {
		gml_pragma("forceinline");
		attributes[? _name] = _value;
		return self;
	};

	/// @func has_attribute([_name])
	/// @param {string} [_name] The name of the attribute.
	/// @return {bool} Returns `true` if the element has the attribute.
	static has_attribute = function () {
		gml_pragma("forceinline");
		if (argument_count == 0)
		{
			return !ds_map_empty(attributes);
		}
		return ds_map_exists(attributes, argument[0]);
	};

	/// @func get_attribute_count()
	/// @return {int} Returns number of attributes of the element.
	static get_attribute_count = function () {
		return ds_map_size(attributes);
	};

	/// @func get_attribute(_name)
	/// @param {string} _name The name of the attribute.
	/// @return {string/real/bool/undefined} The attribute value.
	static get_attribute = function (_name) {
		gml_pragma("forceinline");
		return attributes[? _name];
	};

	/// @func find_first_attribute()
	/// @return {string} The name of the first attribute.
	static find_first_attribute = function () {
		return ds_map_find_first(attributes);
	};

	/// @func find_prev_attribute(_name)
	/// @param {string} _name The name of the current attribute.
	/// @return {string} The name of the previous attribute.
	static find_prev_attribute = function (_name) {
		return ds_map_find_previous(attributes, _name);
	};

	/// @func find_next_attribute(_name)
	/// @param {string} _name The name of the current attribute.
	/// @return {string} The name of the next attribute.
	static find_next_attribute = function (_name) {
		return ds_map_find_next(attributes, _name);
	};

	/// @func remove_attribute(_name)
	/// @param {string} _name The name of the attribute.
	/// @return {CE_XmlElement} Returns `self` to allow method chaining.
	static remove_attribute = function (_name) {
		ds_map_delete(attributes, _name);
		return self;
	};

	/// @func add_child(_child)
	/// @param {CE_XmlElement} _child The child element.
	/// @return {CE_XmlElement} Returns `self` to allow mathod chaining.
	static add_child = function (_child) {
		gml_pragma("forceinline");
		ds_list_add(children, _child);
		_child.parent = self;
		return self;
	};

	/// @func has_children()
	/// @return {bool} Returns `true` if the element has child elements. 
	static has_children = function () {
		gml_pragma("forceinline");
		return !ds_list_empty(children);
	};

	/// @func get_child_count()
	/// @return {int} Returns number of child elements.
	static get_child_count = function () {
		gml_pragma("forceinline");
		return ds_list_size(children);
	};

	/// @func get_child(_index)
	/// @param {int} _index The index of the child element.
	/// @return {CE_XmlElement} Returns a child element with given index.
	/// @see CE_XmlElement.has_children
	/// @see CE_XmlElement.get_child_count
	static get_child = function (_index) {
		gml_pragma("forceinline");
		return children[| _index];
	};
	
	/// @func get_child_by_name(_name)
	/// @param {string} _name The index of the child element.
	/// @return {CE_XmlElement} Returns a child element with given index.
	static get_child_by_name = function (_name) {
		for(var i=0; i<self.get_child_count(); i++) {
			if ( self.children[|i].name == _name )
				return self.children[|i];
		}
		return NULL;
	};

	/// @func destroy()
	/// @desc Frees memory used by the element. Use this in combination with
	/// `delete` to destroy the struct.
	/// @example
	/// ```gml
	/// element.destroy();
	/// delete element;
	/// ```
	static destroy = function () {
		var i = 0;
		repeat (ds_list_size(children))
		{
			children[| i++].destroy();
		}
		ds_list_destroy(children);
		ds_map_destroy(attributes);
	};
	
	/// @func toString()
	/// @desc Prints the document into a string.
	/// @return {string} The created string.
	static toString = function () {
		var _child_count = self.get_child_count();
		var _indent = (argument_count > 0) ? argument[0] : 0;
		var _spaces = string_repeat(" ", _indent * 2);

		// Open element
		var _string = _spaces + "<" + self.name;

		// Attributes
		var _attribute = self.find_first_attribute();

		repeat (self.get_attribute_count())
		{
			_string += " " + string(_attribute) + "=\""
				+ ce_string_unparse(self.get_attribute(_attribute))
				+ "\"";
			_attribute = self.find_next_attribute(_attribute);
		}

		if (_child_count == 0 && is_undefined(self.value))
		{
			_string += "/";
		}

		_string += ">";

		if (_child_count != 0 || is_undefined(self.value))
		{
			_string += chr(10);
		}

		// Children
		for (var i = 0; i < _child_count; ++i)
		{
			var _child_element = self.get_child(i);
			_string += _child_element.toString(_indent + 1);
		}

		// Close element
		if (_child_count != 0)
		{
			_string += _spaces + "</" + self.name + ">" + chr(10);
		}
		else if (!is_undefined(self.value))
		{
			_string += ce_string_unparse(self.value);
			_string += "</" + self.name + ">" + chr(10);
		}

		return _string;
	};
};

/// @func CE_XmlDocument()
/// @desc An XML document.
function CE_XmlDocument() constructor
{
	/// @var {string/undefined}
	/// @readonly
	path = undefined;

	/// @var {CE_XmlElement/undefined}
	root = undefined;

	/// @func load(_path)
	/// @desc Loads an XML document from a file.
	/// @param {string} _path The path to the file to load.
	/// @return {CE_XmlDocument} Returns `self` to allow method chaining.
	/// @throws {CE_XmlError) If the loading fails.
	static load = function (_path) {
		var _file = file_bin_open(_path, 0);
		if (_file == -1)
		{
			throw new CE_XmlError("Could no open file " + _path + "!");
		}

		var _file_pos = 0;
		var _file_size = file_bin_size(_file);
		var _byte = CE_EXmlChars.Space;
		var _is_separator = true;
		var _token = "";
		var _is_string = false;
		var _attribute_name = "";
		var _root = undefined;
		var _element = undefined;
		var _last_element = undefined;
		var _parent_element = undefined;
		var _is_closing = false;
		var _is_comment = false;
		var _last_byte;

		do
		{
			// Read byte from file
			_last_byte = _byte;
			_byte = file_bin_read_byte(_file);

			// Process byte
			_is_separator = true;

			switch (_byte)
			{
			// Start of new element
			case CE_EXmlChars.LT:
				if (_element != undefined)
				{
					if (_root != undefined)
					{
						_root.destroy();
						delete _root;
					}
					throw new CE_XmlError("Unexpected symbol '<' at "
						+ string(_file_pos) + "!");
				}

				// Set element value
				while (string_byte_at(_token, 1) == 32)
				{
					_token = string_delete(_token, 1, 1);
				}

				if (_token != ""
					&& _parent_element != undefined
					&& _parent_element.get_child_count() == 0)
				{
					_parent_element.value = ce_string_parse(_token);
				}

				_element = new CE_XmlElement();
				break;

			// End of element
			case CE_EXmlChars.GT:
				if (_element == undefined)
				{
					if (_root != undefined)
					{
						_root.destroy();
						delete _root;
					}
					throw new CE_XmlError("Unexpected symbol '>' at "
						+ string(_file_pos) + "!");
				}

				_last_element = _element;

				if (_root == undefined && !_is_comment)
				{
					_root = _element;
				}

				if (_is_comment)
				{
					_last_element = undefined;
					_element.destroy();
					delete _element;
					_is_comment = false;
				}
				else if (_last_byte == CE_EXmlChars.Slash)
				{
					// Self-closing element
					if (_parent_element != undefined)
					{
						_parent_element.add_child(_element);
					}
				}
				else if (_is_closing)
				{
					// If the element is not self-closing and it does not
					// have a value defined, then set its value to an empty string.
					if (_parent_element.value == undefined
						&& _parent_element.get_child_count() == 0)
					{
						_parent_element.value = "";
					}
					_parent_element = _parent_element.parent;
					_last_element = undefined;
					_element.destroy();
					delete _element;
					_is_closing = false;
				}
				else
				{
					if (_parent_element != undefined)
					{
						_parent_element.add_child(_element);
					}
					_parent_element = _element;
				}
				_element = undefined;
				break;

			// Closing element
			case CE_EXmlChars.Slash:
				if (_is_string || _element == undefined)
				{
					_is_separator = false;
				}
				else if (_last_byte == CE_EXmlChars.LT)
				{
					_is_closing = true;
				}
				break;

			// Attribute
			case CE_EXmlChars.Equal:
				if (!_is_string)
				{
					if (_token != "")
					{
						_attribute_name = _token;
					}
				} else {
					_is_separator = false;
				}
				break;

			// Start/end of string
			case CE_EXmlChars.SQ:
			case CE_EXmlChars.DQ:
				if (_is_string == _byte)
				{
					_is_string = false;
					// Store attribute
					if (_attribute_name != "")
					{
						if (_element != undefined)
						{
							_element.set_attribute(_attribute_name, ce_string_parse(_token));
						}
						_attribute_name = "";
					}
				}
				else if (!_is_string)
				{
					_is_string = _byte;
				}
				break;

			// Treat as comments
			case CE_EXmlChars.QM:
			case CE_EXmlChars.EM:
				if (_last_byte == CE_EXmlChars.LT)
				{
					_is_comment = true;
				}
				else
				{
					_is_separator = false;
				}
				break;

			default:
				// Whitespace
				if (!_is_string && _element != undefined
					&& ((_byte > CE_EXmlChars.Null && _byte <= CE_EXmlChars.CR)
					|| _byte == CE_EXmlChars.Space))
				{
					// Do nothing...
				}
				else
				{
					_is_separator = false;
				}
				break;
			}

			// Process tokens
			if (_is_separator)
			{
				// End of token
				if (_token != "")
				{ 
					// Set element name
					if (_element != undefined && _element.name == "")
					{
						_element.name = _token;
					}
					else if (_last_element != undefined
						&& _last_element.name == "")
					{
						_last_element.name = _token;
					}
					_token = "";
				}
			}
			else
			{
				// Build token
				if (_byte > CE_EXmlChars.Null && _byte <= CE_EXmlChars.CR)
				{
					// Replace new lines, tabs, etc. with spaces
					_byte = CE_EXmlChars.Space;
				}
				_token += chr(_byte);
			}
		}
		until (++_file_pos == _file_size);

		file_bin_close(_file);

		root = _root;
		return self;
	};

	/// @func to_string()
	/// @desc Prints the document into a string.
	/// @return {string} The created string.
	static to_string = function () {
		return self.root.to_string();
	};

	/// @func save([_path])
	/// @desc Saves the document to a file.
	/// @param {string} [_path] The file path.
	/// @return {CE_XmlDocument} Returns `self` to allow method chaining.
	/// @throws {CE_XmlError} If the save path is not defined.
	static save = function () {
		var _path = (argument_count > 0) ? argument[0] : path;
		if (_path == undefined)
		{
			throw new CE_XmlError("Save path not defined!");
		};
		path = _path;

		var _file = file_text_open_write(_path);
		if (_file == -1)
		{
			throw new CE_XmlError();
		}
		file_text_write_string(_file, to_string());
		file_text_writeln(_file);
		file_text_close(_file);

		return self;
	};

	/// @func destroy()
	/// @desc Frees memory used by the document. Use this in combination with
	/// `delete` to destroy the struct.
	/// @example
	/// ```gml
	/// document.destroy();
	/// delete document;
	/// ```
	static destroy = function () {
		if (root != undefined)
		{
			root.destroy();
			delete root;
		}
	};
};