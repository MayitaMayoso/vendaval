
show_debug_overlay(false);
image_alpha = 0;

// GEOMETRY CONTROLLER
// This controller is in charge of every rendering duty.
// Models, animaitons, shaders, etc... will be controlled in here.
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);
gpu_set_blendenable(true);
gpu_set_cullmode(cull_noculling);
gpu_set_texrepeat(true);
gpu_set_texfilter(false);

#region FORMATS

	// Structure that holds every format on the engine
	Format = {};
	
	// Create the static colored untextured format.
	Format.Colored = {};
	vertex_format_begin();
		vertex_format_add_position_3d();	// Three f32
		vertex_format_add_color();			// Four u8
		vertex_format_add_normal();			// Three f32
	Format.Colored.format = vertex_format_end();
	
	Format.Colored.name = "Static Colored Untextured";
	Format.Colored.size = ( 3 * 4 ) + ( 4 * 1 ) + ( 3 * 4 );
	Format.Colored.AddVertex = function( buffer, position, color, normal) {
		color = DefaultValue(color, new Vector4(255, 255, 255, 1));
		normal = DefaultValue(normal, new Vector3(0, 1, 0));
		vertex_position_3d(buffer, position.x, position.y, position.z);
		vertex_color(buffer, color.rgb, color.w);
		vertex_normal(buffer, normal.x, normal.y, normal.z);
	};
	
	// Create the static uncolored textured format.
	Format.Textured = {};
	vertex_format_begin();
		vertex_format_add_position_3d();	// Three f32
		vertex_format_add_texcoord();		// Two f32
		vertex_format_add_normal();			// Three f32
	Format.Textured.format = vertex_format_end();
	Format.Textured.name = "Static Uncolored Textured";
	Format.Textured.size = ( 3 * 4 ) + ( 3 * 4 ) + ( 2 * 4 );
	Format.Textured.AddVertex = function( buffer, position, textcoord, normal) {
		normal = DefaultValue(normal, new Vector3(0, 1, 0));
		vertex_position_3d(buffer, position.x, position.y, position.z);
		vertex_texcoord(buffer, textcoord.x, textcoord.y);
		vertex_normal(buffer, normal.x, normal.y, normal.z);
	};
	
	// Create the animated uncolored textured format.
	Format.Animated = {};
	vertex_format_begin();
		vertex_format_add_position_3d();	// Three f32
		vertex_format_add_texcoord();		// Two f32
		vertex_format_add_normal();			// Three f32
		//vertex_format_add_color();
		//vertex_format_add_color();
		vertex_format_add_custom(vertex_type_float3, vertex_usage_blendindices);	// Three f32
		vertex_format_add_custom(vertex_type_float3, vertex_usage_blendweight);	// Three f32
	Format.Animated.format = vertex_format_end();
	Format.Animated.name = "Animated Uncolored Textured";
	Format.Animated.size = ( 3 * 4 ) + ( 3 * 4 ) + ( 2 * 4 ) + ( 4 * 1 ) + ( 4 * 1 );
	Format.Animated.AddVertex = function( buffer, position, textcoord, normal, joints, weights) {
		vertex_position_3d(buffer, position.x, position.y, position.z);
		vertex_texcoord(buffer, textcoord.x, textcoord.y);
		vertex_normal(buffer, normal.x, normal.y, normal.z);
		//vertex_color(buffer, make_color_rgb(joints.x, joints.y, joints.z), 0);
		//vertex_color(buffer, make_color_rgb(weights.x*255, weights.y*255, weights.z*255), 0);
		vertex_float3(buffer, joints.x, joints.y, joints.z);
		vertex_float3(buffer, weights.x, weights.y, weights.z);
	};
	
	Format.CleanUp = function() {
		vertex_format_delete(Format.Colored.format);	
		vertex_format_delete(Format.Textured.format);
		vertex_format_delete(Format.Animated.format);
	};
	
#endregion

#region MODELS
	
	// List of every mesh and crontrollers
	models = [];
	
	// Models always have mesh but also can have a texture and animation
	function Model(filename, texture) constructor {

		// Methods of the Model
		static Load = function(filename, texture) {
			// Get the name and the format
			var s = Split(filename, ".");
			var name = s[0];
			var format = s[1];
			
			// Load the model depending on the format given
			var model;
			switch(format) {
				case "obj":
					model = LoadOBJ("models/" + filename, texture);
					self.mesh = model;
					self.skeleton = NULL;
					break;
				case "dae":
					model = LoadDAE("models/" + filename, texture);
					self.mesh = model[0];
					self.skeleton = model[1];
					break;
			}
			
			// Add the new model to the memory and return the new model struct
			self.name = name;
		};
		
		static Draw = function() {
			shader_set(sh_general_render);
			shader_set_uniform_f(shader_get_uniform(sh_general_render, "lightPos"), 10, 10, 10);
			shader_set_uniform_f(shader_get_uniform(sh_general_render, "minDarkness"), 0.3);
			
			if (self.DrawingFunc!=NULL)
				self.DrawingFunc();
			
			if (mesh != NULL)
				if is_array(self.mesh)
					for(var i=0; i<array_length(self.mesh); i++)
						self.mesh[i].Draw();
				else
					self.mesh.Draw();
		};
		
		static CleanUp = function() {
			if (mesh!=NULL) {
				if is_array(self.mesh)
					for(var i=0; i<array_length(self.mesh); i++)
						self.mesh[i].Draw();
				else
					self.mesh.Draw();
				if (skeleton!=NULL) skeleton.CleanUp();
				mesh = NULL;
			}
		};
		
		// Initialization
		self.mesh = NULL;
		self.skeleton = NULL;
		self.DrawingFunc = NULL;
		self.name = "";
		if (filename!=undefined) {
			self.Load(filename, texture);
			array_push(Geometry.models, self);
		}
	};
	
#endregion
