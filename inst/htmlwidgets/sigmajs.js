HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

	factory: function (el, width, height) {

		var s; // initialise

    return {

			renderValue: function (x) {

				// create
				s = new sigma({
					graph: x.data,
					renderer: {
						container: el.id,
						type: x.type
					}
				});

				// pass settings
				if (x.hasOwnProperty('settings')) {
					s.settings(x.settings);
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
						sigma.plugins.animate(s, x.animateMapping);
					}, x.animateDelay);
				}

				s.refresh() // refresh
      },

      resize: function(width, height) {

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

}

