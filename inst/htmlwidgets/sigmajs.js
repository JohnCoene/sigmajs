HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

	factory: function (el, width, height) {

		var s;

    return {

      renderValue: function(x) {

        s = new sigma({
          graph: x.data,
          container: el.id,
          settings: x.settings
        });
        
        if(x.hasOwnProperty('force')){
          s.startForceAtlas2(x.force);
          s.refresh();
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

			},

			getChart: function () {
				return s;
			}

    };
  }
});

function get_sigma_graph(id) {

	var htmlWidgetsObj = HTMLWidgets.find("#" + id);

	var s;

	if (typeof htmlWidgetsObj != 'undefined') {
		s = htmlWidgetsObj.getChart();
	}

	return (s);
}

Shiny.addCustomMessageHandler('sg_add_node_p',
	function (message) {
		var s = get_sigma_graph(message.id);
		if (typeof s != 'undefined') {
			console.log(message);
			s.graph.addNode(
				message.data[0]
			);
			s.refresh();
		}
	});

