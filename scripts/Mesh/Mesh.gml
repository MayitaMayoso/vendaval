function Mesh(buffer, texture, name) constructor {
	// Methods of the mesh
	static Draw = function() {
		if (self.buffer != NULL && self.texture != NULL) {
			vertex_submit(self.buffer, self.primitive, self.texture);
		}
	};
	
	static SetTexture = function(texture) {
		self.texture = sprite_get_texture(texture, 0);
	};
	
	static CleanUp = function() {
		buffer_delete(self.buffer);
	};
	
	// Initialization
	self.buffer = buffer;
	self.texture = texture;
	self.name = DefaultValue(name, "");
	
	if (self.texture!=NULL) self.texture = sprite_get_texture(self.texture, 0);
	
	self.primitive = pr_trianglelist;
};