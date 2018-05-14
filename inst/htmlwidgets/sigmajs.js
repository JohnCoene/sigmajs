HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

        var s = new sigma({
          graph: x.data,
          container: el.id,
          settings: {
              defaultNodeColor: '#ec5148'
          }
        });
        
        if(x.hasOwnProperty('force')){
          s.startForceAtlas2({
            worker: x.force.worker, 
            barnesHutOptimize: x.force.barnesHutOptimize
          });
        }

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
