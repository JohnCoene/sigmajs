HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

	factory: function (el, width, height) {

		var s; // initialise

    return {

			renderValue: function (x) {

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
						settings: x.settings,
						renderer: {
							container: el.id,
							type: x.type
						}
					});
				}

				// start forceAtlas
				if (x.hasOwnProperty('force')) {
					s.startForceAtlas2(x.force);
				}

				// start noverlap
				if (x.hasOwnProperty('noverlap')) {
					var noverlap = s.configNoverlap(x.noverlap);
					if (x.noverlapStart === true) {
						s.startNoverlap();
					}
				}

				// custom shapes
				if (x.customShapes === true) {
					CustomShapes.init(s);
				}

				if (x.animateLoop === false) {
					setTimeout(function () {
						sigma.plugins.animate(s, x.animateMapping, x.animateOptions);
					}, x.animateDelay);
				}

				if(x.hasOwnProperty('dragNodes')){
					var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
				}

				if (x.hasOwnProperty('relativeSize')) {
					sigma.plugins.relativeSize(s, x.relativeSize);
				}
				
				if(x.hasOwnProperty('addNodesDelay')){
  				x.addNodesDelay.forEach((element) => {
  					setTimeout(function () {
  						s.graph.addNode(element);
  						s.refresh();
  					}, element.sigmajsdelay);
  				});
				}
				
				if(x.hasOwnProperty('addEdgesDelay')){
				  var running = s.isForceAtlas2Running();
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

			s.refresh() // refresh

			// stop force
			if(x.hasOwnProperty('forceStopDelay')){
				setTimeout(function () {
					s.stopForceAtlas2();
				}, x.forceStopDelay);
			}
		},

		resize: function(width, height) {
			for(var name in s.renderers)
				s.renderers[name].resize(width, height);
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
				console.log("error")
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
				console.log("error")
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

}

