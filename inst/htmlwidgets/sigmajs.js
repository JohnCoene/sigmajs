HTMLWidgets.widget({

  name: 'sigmajs',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

        var sg = new sigma({
          graph: x.data,
          container: el.id,
          settings: {
              defaultNodeColor: '#ec5148'
          }
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
