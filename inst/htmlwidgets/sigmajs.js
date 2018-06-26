sigma.classes.graph.addMethod('neighbors', function(nodeId) {
    var k,
        neighbors = {},
        index = this.allNeighborsIndex[nodeId] || {};

    for (k in index) {
        neighbors[k] = this.nodesIndex[k];
    }
    return neighbors;
});

HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

	factory: function (el, width, height) {

    var firstRun = true;
		var s, cam, renderer; // initialise s (graph), renderer and cam (camera)
		
    var sel_handle = new crosstalk.SelectionHandle();
    
    sel_handle.on("change", function(ev) {
      
      if (ev.sender !== sel_handle) {
        s.graph.nodes().forEach(function(n) {
          n.color = n.originalColor;
        });
        s.graph.edges().forEach(function(e) {
          e.color = e.originalColor;
        });
        s.refresh();
      }
      
      if (typeof ev.value[0] != 'undefined') {

        var nodeId = ev.value[0];
            toKeep = s.graph.neighbors(nodeId);
        toKeep[nodeId] = s.graph.nodes(String(nodeId));
        sel_handle.set(nodeId);
        s.graph.nodes().forEach(function(n) {
          if (toKeep[n.id])
            n.color = n.originalColor;
          else
            n.color = '#eee';
        });
        s.graph.edges().forEach(function(e) {
          if (toKeep[e.source] && toKeep[e.target])
            e.color = e.originalColor;
          else
            e.color = '#eee';
        });
        s.refresh();

      }

    });
    
    return {

			renderValue: function (x) {
			  
			  var widget = document.getElementById(el.id);
			  var button = widget.getElementsByTagName("button")[0];
			  if(!x.hasOwnProperty('button')){
			    x.button = "none";
			    widget.removeChild(button);
			  } else {
			    button.className = x.button.className;
			    button.innerHTML = x.button.label;
			  }

				// if gexf file
				if (x.hasOwnProperty('gexf')) {

					// create
					s = new sigma(el.id);

					if(x.hasOwnProperty("settings")){
						for (var name in x.settings)
							s.settings(name, x.settings[name]);
					}

					// parse GEXF
					var parser = new DOMParser();
					var data = parser.parseFromString(x.data, "application/xml");

					sigma.parsers.gexf(data, s,
						function() {
						  s.refresh();
						}
					);
				} else {
					// create
  				s = new sigma({
  					graph: x.data,
  					settings: x.settings
  				});
  				// add camera
  				if(x.hasOwnProperty('camera')){
  				  
  				  // get or initialise camera
  				  if(x.camera.init === true){
  				    cam = s.addCamera();
  				  } else {
            	cam = get_sigma_camera(x.camera.id);
  				  }
  				  
  				  renderer = s.addRenderer({
  						container: el.id,
  						type: x.type,
  				    camera: cam
  				  });
    				
  				  s.refresh();
  				} else {
  				  renderer = s.addRenderer({
  						container: el.id,
  						type: x.type
  				  });
  				}
				}
				
				// force neighbours true if crosstalk enabled
				if(typeof x.crosstalk.crosstalk_key !== undefined){
				  x.neighbours = true;
				}
				
				// highlight neighbours
				if(x.hasOwnProperty('neighbours')){
				  db = new sigma.plugins.neighborhoods();

          s.graph.nodes().forEach(function(n) {
            n.originalColor = n.color;
          });
          s.graph.edges().forEach(function(e) {
            e.originalColor = e.color;
          });
          s.bind("clickNode", function(e) {
            var nodeId = e.data.node.id,
                toKeep = s.graph.neighbors(nodeId);
            toKeep[nodeId] = e.data.node;
            sel_handle.set(nodeId);
            s.graph.nodes().forEach(function(n) {
              if (toKeep[n.id])
                n.color = n.originalColor;
              else
                n.color = '#eee';
            });
            s.graph.edges().forEach(function(e) {
              if (toKeep[e.source] && toKeep[e.target])
                e.color = e.originalColor;
              else
                e.color = '#eee';
            });
            s.refresh();
          });
          s.bind("clickStage", function(e) {
            s.graph.nodes().forEach(function(n) {
              n.color = n.originalColor;
            });
            s.graph.edges().forEach(function(e) {
              e.color = e.originalColor;
            });
            s.refresh();
            sel_handle.clear();
          });
				}

				// start forceAtlas
				if (x.hasOwnProperty('force')) {
				  if(x.button.event === 'force' || x.button.event === 'force_start'){
				    button.addEventListener("click", function(event) {
				      s.startForceAtlas2(x.force);
				    });
				  } else {
				    s.startForceAtlas2(x.force);
				  }
				}
				
				// progress
				if(x.hasOwnProperty('progressBar')){
				  var bar = document.createElement(x.progressBar.element);
				  bar.style.textAlign  = x.progressBar.position;
				  
				  // widget
				  var element = document.getElementById(el.id);
				  
				  element.appendChild(bar);
				  button.addEventListener("click", function(event) {
    				x.progressBar.data.forEach((element) => {
    					setTimeout(function () {
    						bar.innerHTML = element.text;
    					}, element.delay);
    				});
				  });
				}

				// start noverlap
				if (x.hasOwnProperty('noverlap')) {
					var noverlap = s.configNoverlap(x.noverlap);
					if (x.noverlapStart === true) {
						s.startNoverlap();
					}
					
				  if(x.button.event === 'noverlap'){
				    button.addEventListener("click", function(event) {
				      s.startNoverlap();
				    });
				  } 
				}

				// custom shapes
				if (x.customShapes === true) {
					CustomShapes.init(s);
				}

				if (x.animateLoop === false) {
					
				  if(x.button.event === 'animate'){
				    button.addEventListener("click", function(event) {
    					setTimeout(function () {
    						sigma.plugins.animate(s, x.animateMapping, x.animateOptions);
    					}, x.animateDelay);
				    });
				  } else {
  					setTimeout(function () {
  						sigma.plugins.animate(s, x.animateMapping, x.animateOptions);
  					}, x.animateDelay);
				  }
				}

				if(x.hasOwnProperty('dragNodes')){
				  if(x.button.event === 'drag_nodes'){
				    button.addEventListener("click", function(event) {
				      var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
				    });
				  } else {
				    var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
				  }
				}

				if (x.hasOwnProperty('relativeSize')) {
				  if(x.button.event === 'relative_size'){
				    button.addEventListener("click", function(event) {
				      sigma.plugins.relativeSize(s, x.relativeSize);
				    });
				  } else {
				    sigma.plugins.relativeSize(s, x.relativeSize);
				  }
				}
				
				if(x.hasOwnProperty('addNodesDelay')){
  				
				  if(x.button.event === 'add_nodes'){
				    button.addEventListener("click", function(event) {
      				x.addNodesDelay.forEach((element) => {
        					setTimeout(function () {
        						s.graph.addNode(element);
        						s.refresh();
        					}, element.sigmajsdelay);
        			});
				    });
				  } else {
    				x.addNodesDelay.forEach((element) => {
    					setTimeout(function () {
    						s.graph.addNode(element);
    						s.refresh();
    					}, element.sigmajsdelay);
    				});
				  }
				}
				
				if(x.hasOwnProperty('addEdgesDelay')){
				  var running = s.isForceAtlas2Running();
  				
				  if(x.button.event === 'add_edges'){
				    button.addEventListener("click", function(event) {
        			x.addEdgesDelay.data.forEach((element) => {
      					setTimeout(function () {
    						if (x.addEdgesDelay.refresh === true && running === true) {
    							s.killForceAtlas2();
    						}
    						s.graph.addEdge(element);
    						if (x.addEdgesDelay.refresh === true && running === true) {
    							s.startForceAtlas2();
    						}
    						if (x.addEdgesDelay.refresh === true) {
    							s.refresh();
    						}
      					}, element.sigmajsdelay);
      				});
				    });
				  } else {
    				x.addEdgesDelay.data.forEach((element) => {
    					setTimeout(function () {
  						if (x.addEdgesDelay.refresh === true && running === true) {
  							s.killForceAtlas2();
  						}
  						s.graph.addEdge(element);
  						if (x.addEdgesDelay.refresh === true && running === true) {
  							s.startForceAtlas2();
  						}
  						if (x.addEdgesDelay.refresh === true) {
  							s.refresh();
  						}
    					}, element.sigmajsdelay);
    				});
				  }
				}
				
				if(x.hasOwnProperty("dropNodesDelay")){
  				
				  if(x.button.event === 'drop_nodes'){
				    button.addEventListener("click", function(event) {
      				x.dropNodesDelay.forEach((element) => {
      					setTimeout(function () {
      						s.graph.dropNode(element.id);
      						s.refresh();
      					}, element.sigmajsdelay);
      				});
				    });
				  } else {
    				x.dropNodesDelay.forEach((element) => {
    					setTimeout(function () {
    						s.graph.dropNode(element.id);
    						s.refresh();
    					}, element.sigmajsdelay);
    				});
				  }
				}
				
				if(x.hasOwnProperty("dropEdgesDelay")){
  				var is_running = s.isForceAtlas2Running();
  				
				  if(x.button.event === 'drop_edges'){
				    button.addEventListener("click", function(event) {
      				x.dropEdgesDelay.data.forEach((element, index) => {
      					setTimeout(function () {
      						if (message.refresh === true && is_running === true) {
      							s.killForceAtlas2();
      						}
      						s.graph.dropEdge(element);
      						if (message.refresh === true && is_running === true) {
      							s.startForceAtlas2();
      						}
      						if (message.refresh === true) {
      							s.refresh();
      						}
      					}, element.sigmajsdelay);
      				});
				    });
				  } else {
    				x.dropEdgesDelay.data.forEach((element, index) => {
    					setTimeout(function () {
    						if (message.refresh === true && running === true) {
    							s.killForceAtlas2();
    						}
    						s.graph.dropEdge(element);
    						if (message.refresh === true && running === true) {
    							s.startForceAtlas2();
    						}
    						if (message.refresh === true) {
    							s.refresh();
    						}
    					}, element.sigmajsdelay);
    				});
				  }
				}


				// events
				if (HTMLWidgets.shinyMode) {
					// click node
					s.bind('clickNode', function (e) {
						Shiny.onInputChange(el.id + '_click_node' + ":sigmajsParse", e.data.node);
					});

					// click nodeS
					s.bind('clickNodes', function (e) {
						Shiny.onInputChange(el.id + '_click_nodes' + ":sigmajsParse", e.data.nodes);
					});

					// click edge
					s.bind('clickEdge', function (e) {
						Shiny.onInputChange(el.id + '_click_edge' + ":sigmajsParse", e.data.edge);
					});

					// click edgeS
					s.bind('clickEdges', function (e) {
						Shiny.onInputChange(el.id + '_click_edges' + ":sigmajsParse", e.data.edges);
					});

					// click stage
					s.bind('clickStage', function (e) {
						Shiny.onInputChange(el.id + '_click_stage' + ":sigmajsParse", true);
					});

					// double click stage
					s.bind('doubleClickStage', function (e) {
						Shiny.onInputChange(el.id + '_double_click_stage' + ":sigmajsParse", true);
					});

					// right click stage
					s.bind('rightClickStage', function (e) {
						Shiny.onInputChange(el.id + '_right_click_stage' + ":sigmajsParse", true);
					});

					// double click node
					s.bind('doubleClickNode', function (e) {
						Shiny.onInputChange(el.id + '_double_click_node' + ":sigmajsParse", e.data.node);
					});

					// double click nodeS
					s.bind('doubleClickNodes', function (e) {
						Shiny.onInputChange(el.id + '_double_click_nodes' + ":sigmajsParse", e.data.nodes);
					});

					// double click edge
					s.bind('doubleClickEdge', function (e) {
						Shiny.onInputChange(el.id + '_double_click_edge' + ":sigmajsParse", e.data.edge);
					});

					// double click edgeS
					s.bind('doubleClickEdges', function (e) {
						Shiny.onInputChange(el.id + '_double_click_edges' + ":sigmajsParse", e.data.edges);
					});

					// right click node
					s.bind('rightClickNode', function (e) {
						Shiny.onInputChange(el.id + '_right_click_node' + ":sigmajsParse", e.data.node);
					});

					// right click nodeS
					s.bind('rightClickNodes', function (e) {
						Shiny.onInputChange(el.id + '_right_click_nodes' + ":sigmajsParse", e.data.nodes);
					});

					// right click edge
					s.bind('rightClickEdge', function (e) {
						Shiny.onInputChange(el.id + '_right_click_edge' + ":sigmajsParse", e.data.edge);
					});

					// right click edgeS
					s.bind('rightClickEdges', function (e) {
						Shiny.onInputChange(el.id + '_right_click_edges' + ":sigmajsParse", e.data.edges);
					});

					// over node
					s.bind('overNode', function (e) {
						Shiny.onInputChange(el.id + '_over_node' + ":sigmajsParse", e.data.node);
					});

					// over nodeS
					s.bind('overNodes', function (e) {
						Shiny.onInputChange(el.id + '_over_nodes' + ":sigmajsParse", e.data.nodes);
					});

					// over edge
					s.bind('overEdge', function (e) {
						Shiny.onInputChange(el.id + '_over_edge' + ":sigmajsParse", e.data.edge);
					});

					// over edgeS
					s.bind('overEdges', function (e) {
						Shiny.onInputChange(el.id + '_over_edges' + ":sigmajsParse", e.data.edges);
					});

					// out node
					s.bind('outNode', function (e) {
						Shiny.onInputChange(el.id + '_out_node' + ":sigmajsParse", e.data.node);
					});

					// out nodeS
					s.bind('outNodes', function (e) {
						Shiny.onInputChange(el.id + '_out_nodes' + ":sigmajsParse", e.data.nodes);
					});

					// out edge
					s.bind('outEdge', function (e) {
						Shiny.onInputChange(el.id + '_out_edge' + ":sigmajsParse", e.data.edge);
					});

					// out edgeS
					s.bind('outEdges', function (e) {
						Shiny.onInputChange(el.id + '_out_edges' + ":sigmajsParse", e.data.edges);
					});
				}

			s.refresh(); // refresh

			// stop force
			if(x.hasOwnProperty('forceStopDelay')){
			  if(x.button.event === 'force_stop'){
			    button.addEventListener("click", function(event) {
    				setTimeout(function () {
    					s.stopForceAtlas2();
    				}, x.forceStopDelay);
			    });
			  } else {
    			setTimeout(function () {
    				s.stopForceAtlas2();
    			}, x.forceStopDelay);
			  }
			}
			
			if(x.hasOwnProperty('export')){
		    button.addEventListener("click", function(event) {
  				var output = s.toSVG(x.export);
		    });
			}
			
      sel_handle.setGroup(x.crosstalk.crosstalk_group);
      //filter_handle.setGroup(x.crosstalk.crosstalk_group);
			
		},

		resize: function(width, height) {
			for(var name in s.renderers)
				s.renderers[name].resize(width, height);
		},
		
		getCamera: function() {
		  return cam;
		},

		getChart: function () {
			return s;
		}

    };
  }
});


// get chart
function get_sigma_graph(id) {

	var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

	var s; // define

	if (typeof htmlWidgetsObj != 'undefined') { // get chart if defined
		s = htmlWidgetsObj.getChart();
	}

	return (s);
}

// get camera
function get_sigma_camera(id) {

	var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

	var c; // define

	if (typeof htmlWidgetsObj != 'undefined') { // get chart if defined
		c = htmlWidgetsObj.getCamera();
	}

	return (c);
}

// only in shiny
if (HTMLWidgets.shinyMode) {

	// add node
	Shiny.addCustomMessageHandler('sg_add_node_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.addNode(
					message.data[0]
				);
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// add edge
	Shiny.addCustomMessageHandler('sg_add_edge_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.addEdge(
					message.data[0]
				);
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// restart forceAtlas2
	Shiny.addCustomMessageHandler('sg_force_restart_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				var running = s.isForceAtlas2Running();
				if (running === true) {
					s.killForceAtlas2();
				}
				if (running === false) {
					s.startForceAtlas2(message.data);
					if (message.refresh === true) {
						s.refresh();
					}
				}
			}
		}
	);

	// start forceAtlas2
	Shiny.addCustomMessageHandler('sg_force_start_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.startForceAtlas2(message.data);
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// stop forceAtlas2
	Shiny.addCustomMessageHandler('sg_force_stop_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.stopForceAtlas2();
			}
		}
	);

	// stop forceAtlas2
	Shiny.addCustomMessageHandler('sg_force_config_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.configForceAtlas2(message.data);
			}
		}
	);

	// kill forceAtlas2
	Shiny.addCustomMessageHandler('sg_force_kill_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.killForceAtlas2();
			}
		}
	);

	// refresh
	Shiny.addCustomMessageHandler('sg_refresh_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.refresh();
			}
		}
	);

	// drop node
	Shiny.addCustomMessageHandler('sg_drop_node_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.dropNode(message.data);
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// drop edge
	Shiny.addCustomMessageHandler('sg_drop_edge_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.dropEdge(message.data);
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// clear graph
	Shiny.addCustomMessageHandler('sg_clear_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.clear();
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// kill graph
	Shiny.addCustomMessageHandler('sg_kill_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				s.graph.kill();
				if (message.refresh === true) {
					s.refresh();
				}
			}
		}
	);

	// add nodes
	Shiny.addCustomMessageHandler('sg_add_nodes_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				message.data.forEach((element) => {
					s.graph.addNode(element);
					if (message.refresh === true && message.rate === "iteration") {
						s.refresh();
					}
				});

				if (message.refresh === true && message.rate === "once") {
					s.refresh();
				}
			}
		}
	);

	// add edges
	Shiny.addCustomMessageHandler('sg_add_edges_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				message.data.forEach((element) => {
					s.graph.addEdge(element);
					if (message.refresh === true && message.rate === "iteration") {
						s.refresh();
					}
				});

				if (message.refresh === true && message.rate === "once") {
					s.refresh();
				}
			}
		}
	);

	// add nodes delay
	Shiny.addCustomMessageHandler('sg_add_nodes_delay_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				message.data.forEach((element) => {
					setTimeout(function () {
						s.graph.addNode(element);
						s.refresh();
					}, element.sigmajsdelay);
				});
			} else {
				console.log("error");
			}
		}
	);
	
	Shiny.addCustomMessageHandler('sg_drop_nodes_delay_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				message.data.forEach((element) => {
					setTimeout(function () {
						s.graph.dropNode(element.id);
						s.refresh();
					}, element.sigmajsdelay);
				});
			} else {
				console.log("error");
			}
		}
	);
	
	// add edges delay
	Shiny.addCustomMessageHandler('sg_drop_edges_delay_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				var running = s.isForceAtlas2Running();
				message.data.forEach((element, index) => {
					setTimeout(function () {
						if (message.refresh === true && running === true) {
							s.killForceAtlas2();
						}
						s.graph.dropEdge(element.id);
						if (message.refresh === true && running === true) {
							s.startForceAtlas2();
						}
						if (message.refresh === true) {
							s.refresh();
						}
					}, element.sigmajsdelay);
				});
			} else {
				console.log("error");
			}
		}
	);

	// add edges delay
	Shiny.addCustomMessageHandler('sg_add_edges_delay_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				var running = s.isForceAtlas2Running();
				message.data.forEach((element, index) => {
					setTimeout(function () {
						if (message.refresh === true && running === true) {
							s.killForceAtlas2();
						}
						s.graph.addEdge(element);
						if (message.refresh === true && running === true) {
							s.startForceAtlas2();
						}
						if (message.refresh === true) {
							s.refresh();
						}
					}, element.sigmajsdelay);
				});
			} else {
				console.log("error");
			}
		}
	);

	// start drag nodes
	Shiny.addCustomMessageHandler('sg_drag_nodes_start_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
			}
		}
	);

	// kill drag nodes
	Shiny.addCustomMessageHandler('sg_drag_nodes_kill_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				sigma.plugins.killDragNodes(s);
			}
		}
	);
	
	// export
	Shiny.addCustomMessageHandler('sg_export_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			if (typeof s != 'undefined') {
				var output = s.toSVG(message.data);
			}
		}
	);
	
	// filter greater than
	Shiny.addCustomMessageHandler('sg_filter_gt_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			
			if (typeof s != 'undefined') {
			  
			  var filter = new sigma.plugins.filter(s);
			  
			  if(message.target === "both"){
          filter
            .undo()
            .nodesBy(function(n) {
              return n[message.var] > message.input;
            })
            .edgesBy(function(e) {
              return e[message.var] > message.input;
            })
            .apply();
			  } else if(message.target === "nodes"){
          filter
            .undo()
            .nodesBy(function(n) {
              return n[message.var] > message.input;
            })
            .apply();
			  } else {
          filter
            .undo()
            .edgesBy(function(e) {
              return e[message.var] > message.input;
            })
            .apply();
			  }
				
			}
		}
	);
	
	// filter less than
	Shiny.addCustomMessageHandler('sg_filter_lt_p',
		function (message) {
			var s = get_sigma_graph(message.id);
			
			if (typeof s != 'undefined') {
			  
			  var filter = new sigma.plugins.filter(s);
			  
			  if(message.target === "both"){
          filter
            .undo()
            .nodesBy(function(n) {
              return n[message.var] < message.input;
            })
            .edgesBy(function(e) {
              return e[message.var] < message.input;
            })
            .apply();
			  } else if(message.target === "nodes"){
          filter
            .undo()
            .nodesBy(function(n) {
              return n[message.var] < message.input;
            })
            .apply();
			  } else {
          filter
            .undo()
            .edgesBy(function(e) {
              return e[message.var] < message.input;
            })
            .apply();
			  }
				
			}
		}
	);

}
