sigma.classes.graph.addMethod("neighbors", function (nodeId) {
  var k,
    neighbors = {},
    index = this.allNeighborsIndex[nodeId] || {};

  for (k in index) {
    neighbors[k] = this.nodesIndex[k];
  }
  return neighbors;
});

HTMLWidgets.widget({
  name: "sigmajs",

  type: "output",

  factory: function (el, width, height) {
    var initialized = false;
    var s, cam, renderer;

    var sel_handle = new crosstalk.SelectionHandle();

    return {
      renderValue: function (x) {
        var btn;
        for (var i = 0; i < x.button.length; i++) {
          btn = document.getElementById(x.button[i].id);
          x.button[i].btn = btn;
        }

        // if gexf file
        if (x.hasOwnProperty("gexf")) {
          // create
          s = new sigma(el.id);

          if (x.hasOwnProperty("settings")) {
            for (var name in x.settings) s.settings(name, x.settings[name]);
          }

          // parse GEXF
          var parser = new DOMParser();
          var data = parser.parseFromString(x.data, "application/xml");

          sigma.parsers.gexf(data, s, function () {
            s.refresh();
          });
        } else {
          if (HTMLWidgets.shinyMode) {
            sigInst = document.getElementById(el.id);
            while (sigInst.firstChild) {
              sigInst.removeChild(sigInst.firstChild);
            }
          }

          s = new sigma({
            graph: x.data,
            settings: x.settings,
          });
          s.refresh();

          renderer = s.addRenderer({
            container: el.id,
            type: sigma.renderers.canvas,
          });
        }

        // force neighbours true if crosstalk enabled
        if (
          x.crosstalk.crosstalk_key !== null &&
          !x.hasOwnProperty("neighbours")
        ) {
          x.neighbours = [];
          x.neighbours.edges = "#eee";
          x.neighbours.nodes = "#eee";
          x.neighbours.on = "clickNode";
        }

        // highlight neighbours
        if (x.hasOwnProperty("neighbours")) {
          db = new sigma.plugins.neighborhoods();

          s.graph.nodes().forEach(function (n) {
            n.originalColor = n.color;
          });
          s.graph.edges().forEach(function (e) {
            e.originalColor = e.color;
          });
          var nodeHasBeenClicked = false;
          // x.neighbours.on can be "clickNode", "overNode" or "clickNode|overNode",
          // which means neighbour highlighting is triggered by both click and hover.
          // Bind on all events provided, potentially separated by "|":
          x.neighbours.on.split("|").forEach(function (on) {
            s.bind(on, function (e) {
              if (on == "overNode" && nodeHasBeenClicked) {
                // do not highlight another hovered node, we are locked by user clicking on a node
                return;
              }
              var nodeId = e.data.node.id;
              if (on == "clickNode") {
                nodeHasBeenClicked = true; // lock highlighting at this node
              }
              // -- Finding connected nodes --
              // start by selecting all edges between nodeId and other nodes:
              var neighborEdges = s.graph.adjacentEdges(nodeId); // .toString()
              // keep only *visible* (not 'hidden') edges:
              neighborEdges = neighborEdges.filter(function (x) {
                return !x.hidden;
              });
              // extract the IDs of the connected nodes:
              var allIDs = neighborEdges
                .map(function (x) {
                  return [x.source, x.target];
                })
                .flat();
              // deduplicate using an object:
              var toKeep = {};
              for (let id of allIDs) {
                toKeep[id] = true;
              }
              // done.
              // --
              sel_handle.set(nodeId);
              s.graph.nodes().forEach(function (n) {
                if (toKeep[n.id]) n.color = n.originalColor;
                else n.color = x.neighbours.nodes;
              });
              s.graph.edges().forEach(function (e) {
                // highlight all edges of connected nodes:
                // if (toKeep[e.source] && toKeep[e.target])
                // only highlight edges connected to the selected node:
                if (
                  (toKeep[e.source] && e.target == nodeId) ||
                  (e.source == nodeId && toKeep[e.target])
                )
                  e.color = e.originalColor;
                else e.color = x.neighbours.edges;
              });
              s.refresh();
            });
          });
          x.neighbours.on.split("|").forEach(function (on) {
            on = on == "overNode" ? "outNode" : "clickStage";
            s.bind(on, function (e) {
              if (on == "outNode" && nodeHasBeenClicked) {
                // do not stop highlighting on mouse out, we are locked into highlighting by user clicking
                return;
              }
              if (on == "clickStage") {
                if (e.data.captor.isDragging) {
                  return; // ignore clicks while dragging
                }
                nodeHasBeenClicked = false; // stop locking of highlighting
              }
              s.graph.nodes().forEach(function (n) {
                n.color = n.originalColor;
              });
              s.graph.edges().forEach(function (e) {
                e.color = e.originalColor;
              });
              s.refresh();
              sel_handle.clear();
            });
          });
        }

        sel_handle.on("change", function (ev) {
          if (ev.sender !== sel_handle) {
            s.graph.nodes().forEach(function (n) {
              n.color = n.originalColor;
            });
            s.graph.edges().forEach(function (e) {
              e.color = e.originalColor;
            });
            s.refresh();
          }

          if (typeof ev.value[0] != "undefined") {
            var nodeId = ev.value[0];
            toKeep = s.graph.neighbors(nodeId);
            toKeep[nodeId] = s.graph.nodes(String(nodeId));
            sel_handle.set(nodeId);
            s.graph.nodes().forEach(function (n) {
              if (toKeep[n.id]) n.color = n.originalColor;
              else n.color = x.neighbours.nodes;
            });
            s.graph.edges().forEach(function (e) {
              // highlight all edges of connected nodes:
              // if (toKeep[e.source] && toKeep[e.target])
              // only highlight edges connected to the selected node:
              if (
                (toKeep[e.source] && e.target == nodeId) ||
                (e.source == nodeId && toKeep[e.target])
              )
                e.color = e.originalColor;
              else e.color = x.neighbours.edges;
            });
            s.refresh();
          }
        });

        // start forceAtlas
        if (x.hasOwnProperty("force")) {
          if (
            x.buttonevent.indexOf("force") > -1 ||
            x.buttonevent.indexOf("force_start") > -1
          ) {
            for (var a = 0; a < x.button.length; a++) {
              if (
                x.button[a].event.indexOf("force") > -1 ||
                x.button[a].event.indexOf("force_start") > -1
              ) {
                x.button[a].btn.addEventListener("click", function (event) {
                  s.startForceAtlas2(x.force);
                });
              }
            }
          } else {
            s.startForceAtlas2(x.force);
          }
        }

        // progress
        if (x.hasOwnProperty("progressBar")) {
          var bar = document.getElementById(x.progressBar.id);

          if (x.buttonevent.indexOf("progress") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("progress") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  x.progressBar.data.forEach((element) => {
                    setTimeout(function () {
                      bar.innerHTML = element.text;
                    }, element.delay);
                  });
                });
              }
            }
          } else {
            x.progressBar.data.forEach((element) => {
              setTimeout(function () {
                bar.innerHTML = element.text;
              }, element.delay);
            });
          }
        }

        // start noverlap
        if (x.hasOwnProperty("noverlap")) {
          var noverlap = s.configNoverlap(x.noverlap);

          if (x.buttonevent.indexOf("noverlap") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("noverlap") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  s.startNoverlap();
                });
              }
            }
          } else {
            s.startNoverlap();
          }
        }

        // custom shapes
        if (x.customShapes === true) {
          CustomShapes.init(s);
        }

        if (x.animateLoop === false) {
          if (x.buttonevent.indexOf("animate") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("animate") > -1) {
                x.button[i],
                  btn.addEventListener("click", function (event) {
                    setTimeout(function () {
                      sigma.plugins.animate(
                        s,
                        x.animateMapping,
                        x.animateOptions
                      );
                    }, x.animateDelay);
                  });
              }
            }
          } else {
            setTimeout(function () {
              sigma.plugins.animate(s, x.animateMapping, x.animateOptions);
            }, x.animateDelay);
          }
        }

        if (x.hasOwnProperty("dragNodes")) {
          if (x.buttonevent.indexOf("drag_nodes") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("drag_nodes") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
                });
              }
            }
          } else {
            var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
          }
        }

        if (x.hasOwnProperty("relativeSize")) {
          if (x.buttonevent.indexOf("relative_size") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("relative_size") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  sigma.plugins.relativeSize(s, x.relativeSize);
                });
              }
            }
          } else {
            sigma.plugins.relativeSize(s, x.relativeSize);
          }
        }

        if (x.hasOwnProperty("addNodesDelay")) {
          if (
            x.buttonevent.indexOf("add_nodes") > -1 ||
            x.buttonevent.indexOf("add_nodes_edges") > -1
          ) {
            for (var i = 0; i < x.button.length; i++) {
              if (
                x.button[i].event.indexOf("add_nodes") > -1 ||
                x.button[i].event.indexOf("add_nodes_edges") > -1
              ) {
                x.button[i].btn.addEventListener("click", function (event) {
                  x.addNodesDelay.forEach((element) => {
                    setTimeout(function () {
                      s.graph.addNode(element);
                      s.refresh();
                    }, element.sigmajsdelay);
                  });
                });
              }
            }
          } else {
            x.addNodesDelay.forEach((element) => {
              setTimeout(function () {
                s.graph.addNode(element);
                s.refresh();
              }, element.sigmajsdelay);
            });
          }
        }

        if (x.hasOwnProperty("addEdgesDelay")) {
          var running = s.isForceAtlas2Running();

          if (
            x.buttonevent.indexOf("add_edges") > -1 ||
            x.buttonevent.indexOf("add_nodes_edges") > -1
          ) {
            for (var i = 0; i < x.button.length; i++) {
              if (
                x.button[i].event.indexOf("add_edges") > -1 ||
                x.button[i].event.indexOf("add_nodes_edges") > -1
              ) {
                x.button[i].btn.addEventListener("click", function (event) {
                  x.addEdgesDelay.data.forEach((element) => {
                    setTimeout(function () {
                      if (
                        x.addEdgesDelay.refresh === true &&
                        running === true
                      ) {
                        s.killForceAtlas2();
                      }
                      s.graph.addEdge(element);
                      if (
                        x.addEdgesDelay.refresh === true &&
                        running === true
                      ) {
                        s.startForceAtlas2();
                      }
                      if (x.addEdgesDelay.refresh === true) {
                        s.refresh();
                      }
                    }, element.sigmajsdelay);
                  });
                });
              }
            }
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

        if (x.hasOwnProperty("dropEdgesDelay")) {
          var is_running = s.isForceAtlas2Running();

          if (x.buttonevent.indexOf("drop_edges") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("drop_edges") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  x.dropEdgesDelay.data.forEach((drop_edg, index) => {
                    setTimeout(function () {
                      if (
                        x.dropEdgesDelay.refresh === true &&
                        is_running === true
                      ) {
                        s.killForceAtlas2();
                      }
                      s.graph.dropEdge(drop_edg.id);
                      if (
                        x.dropEdgesDelay.refresh === true &&
                        is_running === true
                      ) {
                        s.startForceAtlas2();
                      }
                      if (x.dropEdgesDelay.refresh === true) {
                        s.refresh();
                      }
                    }, drop_edg.sigmajsdelay);
                  });
                });
              }
            }
          } else {
            x.dropEdgesDelay.data.forEach((drop_edg, index) => {
              setTimeout(function () {
                if (x.dropEdgesDelay.refresh === true && is_running === true) {
                  s.killForceAtlas2();
                }
                s.graph.dropEdge(drop_edg.id);
                if (x.dropEdgesDelay.refresh === true && is_running === true) {
                  s.startForceAtlas2();
                }
                if (x.dropEdgesDelay.refresh === true) {
                  s.refresh();
                }
              }, drop_edg.sigmajsdelay);
            });
          }
        }

        if (x.hasOwnProperty("dropNodesDelay")) {
          if (x.buttonevent.indexOf("drop_nodes") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("drop_nodes") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  x.dropNodesDelay.forEach((element) => {
                    setTimeout(function () {
                      s.graph.dropNode(element.id);
                      s.refresh();
                    }, element.sigmajsdelay);
                  });
                });
              }
            }
          } else {
            x.dropNodesDelay.forEach((element) => {
              setTimeout(function () {
                s.graph.dropNode(element.id);
                s.refresh();
              }, element.sigmajsdelay);
            });
          }
        }

        // stop force
        if (x.hasOwnProperty("forceStopDelay")) {
          if (x.buttonevent.indexOf("force_stop") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              if (x.button[i].event.indexOf("force_stop") > -1) {
                x.button[i].btn.addEventListener("click", function (event) {
                  setTimeout(function () {
                    s.stopForceAtlas2();
                  }, x.forceStopDelay);
                });
              }
            }
          } else {
            setTimeout(function () {
              s.stopForceAtlas2();
            }, x.forceStopDelay);
          }
        }

        if (x.hasOwnProperty("forceRestartDelay")) {
          var is_it_running = s.isForceAtlas2Running();

          if (is_it_running === false) {
            s.startForceAtlas2();
          }

          x.forceRestartDelay.forEach((force) => {
            setTimeout(function () {
              s.killForceAtlas2();
              s.startForceAtlas2();
            }, force.sigmajsdelay);
          });
        }

        if (x.hasOwnProperty("exportSVG")) {
          if (x.buttonevent.indexOf("export_svg") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              x.button[i].btn.addEventListener("click", function (event) {
                var output = s.toSVG(x.exportSVG);
              });
            }
          }
        }

        if (x.hasOwnProperty("exportIMG")) {
          if (x.buttonevent.indexOf("export_img") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              x.button[i].btn.addEventListener("click", function (event) {
                var output = renderer.snapshot(x.exportIMG);
              });
            }
          }
        }

        if (x.hasOwnProperty("read")) {
          var is_it_running = s.isForceAtlas2Running();

          if (x.buttonevent.indexOf("read_exec") > -1) {
            for (var i = 0; i < x.button.length; i++) {
              x.button[i].btn.addEventListener("click", function (event) {
                x.read.data.forEach(function (data) {
                  setTimeout(function () {
                    if (x.read.refresh == true && is_it_running == true)
                      s.killForceAtlas2();

                    s.graph.read(data);

                    if (x.read.refresh == true && is_it_running == true)
                      s.startForceAtlas2();
                  }, data.nodes[0].delay);
                });
              });
            }
          } else {
            x.read.data.forEach(function (data) {
              setTimeout(function () {
                if (x.read.refresh == true && is_it_running == true)
                  s.killForceAtlas2();

                s.graph.read(data);

                if (x.read.refresh == true && is_it_running == true)
                  s.startForceAtlas2();
              }, data.nodes[0].delay);
            });
          }
        }

        sel_handle.setGroup(x.crosstalk.crosstalk_group);
        //filter_handle.setGroup(x.crosstalk.crosstalk_group);
        s.refresh(); // refresh

        // events
        if (HTMLWidgets.shinyMode) {
          let events = [];
          let object_notation = false;
          if (x.events.length > 0) {
            if (typeof x.events[0] === "string") {
              // it is format 'c("eventA", "eventB")' in R with default priority everywhere
              events = x.events;
            } else if (typeof x.events[0] === "object") {
              // it is format 'list(list(event = "eventA"), list(event = "eventB", priority = "event"))'
              //   in R where different priority may be set
              object_notation = true;
              events = x.events.map(function (x) {
                return x.event;
              });
            }
          }

          function bindEvent(
            evt_name_js,
            evt_name_shiny,
            what_to_return,
            default_priority
          ) {
            if (events.includes(evt_name_js)) {
              s.bind(evt_name_js, function (e) {
                let return_value = null;
                switch (what_to_return) {
                  case "node":
                    return_value = e.data.node;
                    break;
                  case "nodes":
                    return_value = e.data.nodes;
                    break;
                  case "edge":
                    return_value = e.data.edge;
                    break;
                  case "edges":
                    return_value = e.data.edges;
                    break;
                  case "captor":
                    return_value = e.data.captor;
                    break;
                  default:
                    return_value = what_to_return;
                }
                let inputvalue_set = false;
                if (object_notation) {
                  let idx = events.indexOf(evt_name_js);
                  if (typeof x.events[idx].priority !== "undefined") {
                    Shiny.setInputValue(
                      el.id + evt_name_shiny + ":sigmajsParseJS",
                      return_value,
                      { priority: x.events[idx].priority }
                    );
                    inputvalue_set = true;
                  }
                }
                if (!inputvalue_set)
                  if (typeof default_priority === "undefined") {
                    Shiny.setInputValue(
                      el.id + evt_name_shiny + ":sigmajsParseJS",
                      return_value
                    );
                  } else {
                    Shiny.setInputValue(
                      el.id + evt_name_shiny + ":sigmajsParseJS",
                      return_value,
                      { priority: default_priority }
                    );
                  }
              });
            }
          }

          bindEvent("clickNode", "_click_node", "node");
          bindEvent("clickNodes", "_click_nodes", "nodes");
          bindEvent("clickEdge", "_click_edge", "edge");
          bindEvent("clickEdges", "_click_edges", "edges");
          bindEvent("clickStage", "_click_stage", "captor", "event");
          bindEvent("doubleClickNode", "_double_click_node", "node");
          bindEvent("doubleClickNodes", "_double_click_nodes", "nodes");
          bindEvent("doubleClickEdge", "_double_click_edge", "edge");
          bindEvent("doubleClickEdges", "_double_click_edges", "edges");
          bindEvent("doubleClickStage", "_double_click_stage", "doubleClickStage", "event");
          bindEvent("rightClickNode", "_right_click_node", "node");
          bindEvent("rightClickNodes", "_right_click_nodes", "nodes");
          bindEvent("rightClickEdge", "_right_click_edge", "edge");
          bindEvent("rightClickEdges", "_right_click_edges", "edges");
          bindEvent("rightClickStage", "_right_click_stage", "rightClickStage", "event");
          bindEvent("overNode", "_over_node", "node");
          bindEvent("overNodes", "_over_nodes", "nodes");
          bindEvent("overEdge", "_over_edge", "edge");
          bindEvent("overEdges", "_over_edges", "edges");
          bindEvent("outNode", "_out_node", "node");
          bindEvent("outNodes", "_out_nodes", "nodes");
          bindEvent("outEdge", "_out_edge", "edge");
          bindEvent("outEdges", "_out_edges", "edges");
        }

        var initialized = true;
      },

      resize: function (width, height) {
        for (var name in s.renderers) s.renderers[name].resize(width, height);
      },

      getCamera: function () {
        return cam;
      },

      getEl: function () {
        return el.id;
      },

      getChart: function () {
        return s;
      },

      getRenderer: function () {
        return renderer;
      },
    };
  },
});

// get chart
function get_sigma_graph(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

  var s; // define

  if (typeof htmlWidgetsObj != "undefined") {
    // get chart if defined
    s = htmlWidgetsObj.getChart();
  }

  return s;
}

// get element id
function get_sigma_element(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

  var s; // define

  if (typeof htmlWidgetsObj != "undefined") {
    // get chart if defined
    s = htmlWidgetsObj.getEl();
  }

  return s;
}

// get camera
function get_sigma_camera(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

  var c; // define

  if (typeof htmlWidgetsObj != "undefined") {
    // get chart if defined
    c = htmlWidgetsObj.getCamera();
  }

  return c;
}

// get renderer
function get_sigma_renderer(id) {
  var htmlWidgetsObj = HTMLWidgets.find("#" + id); // find object

  var r; // define

  if (typeof htmlWidgetsObj != "undefined") {
    // get chart if defined
    r = htmlWidgetsObj.getRenderer();
  }

  return r;
}

// only in shiny
if (HTMLWidgets.shinyMode) {
  // add node
  Shiny.addCustomMessageHandler("sg_add_node_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.addNode(message.data[0]);
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // add edge
  Shiny.addCustomMessageHandler("sg_add_edge_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.addEdge(message.data[0]);
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // restart forceAtlas2
  Shiny.addCustomMessageHandler("sg_force_restart_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
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
  });

  // start forceAtlas2
  Shiny.addCustomMessageHandler("sg_force_start_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.startForceAtlas2(message.data);
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // stop forceAtlas2
  Shiny.addCustomMessageHandler("sg_force_stop_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.stopForceAtlas2();
    }
  });

  // settings
  Shiny.addCustomMessageHandler("sg_settings_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      for (var name in message.opts) s.settings(name, message.opts[name]);
      s.refresh();
    }
  });

  // stop forceAtlas2
  Shiny.addCustomMessageHandler("sg_force_config_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.configForceAtlas2(message.data);
    }
  });

  // kill forceAtlas2
  Shiny.addCustomMessageHandler("sg_force_kill_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.killForceAtlas2();
    }
  });

  // refresh
  Shiny.addCustomMessageHandler("sg_refresh_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.refresh();
    }
  });

  // drop node
  Shiny.addCustomMessageHandler("sg_drop_node_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.dropNode(message.data);
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // drop edge
  Shiny.addCustomMessageHandler("sg_drop_edge_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.dropEdge(message.data);
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // clear graph
  Shiny.addCustomMessageHandler("sg_clear_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.clear();
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // kill graph
  Shiny.addCustomMessageHandler("sg_kill_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.kill();
      if (message.refresh === true) {
        s.refresh();
      }
    }
  });

  // add nodes
  Shiny.addCustomMessageHandler("sg_add_nodes_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
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
  });

  // add edges
  Shiny.addCustomMessageHandler("sg_add_edges_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
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
  });

  // add nodes delay
  Shiny.addCustomMessageHandler("sg_add_nodes_delay_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      message.data.forEach((element) => {
        setTimeout(function () {
          s.graph.addNode(element);
          s.refresh();
        }, element.sigmajsdelay);
      });
    } else {
      console.log("error");
    }
  });

  Shiny.addCustomMessageHandler("sg_drop_nodes_delay_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      message.data.forEach((element) => {
        setTimeout(function () {
          s.graph.dropNode(element.id);
          s.refresh();
        }, element.sigmajsdelay);
      });
    } else {
      console.log("error");
    }
  });

  Shiny.addCustomMessageHandler("sg_drop_nodes_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      message.data.forEach((element) => {
        s.graph.dropNode(element);
        if (message.refresh === true && message.rate === "iteration") {
          s.refresh();
        }
      });

      if (message.refresh === true && message.rate === "once") {
        s.refresh();
      }
    }
  });

  Shiny.addCustomMessageHandler("sg_drop_edges_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      message.data.forEach((element) => {
        s.graph.dropEdge(element);
        if (message.refresh === true && message.rate === "iteration") {
          s.refresh();
        }
      });

      if (message.refresh === true && message.rate === "once") {
        s.refresh();
      }
    }
  });

  // add edges delay
  Shiny.addCustomMessageHandler("sg_drop_edges_delay_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
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
  });

  // add edges delay
  Shiny.addCustomMessageHandler("sg_add_edges_delay_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
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
  });

  // start drag nodes
  Shiny.addCustomMessageHandler("sg_drag_nodes_start_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      var dragListener = sigma.plugins.dragNodes(s, s.renderers[0]);
    }
  });

  // kill drag nodes
  Shiny.addCustomMessageHandler("sg_drag_nodes_kill_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      sigma.plugins.killDragNodes(s);
    }
  });

  // read data
  Shiny.addCustomMessageHandler("sg_read_exec_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      s.graph.read(message.data);
    }
  });

  // read batch data
  Shiny.addCustomMessageHandler("sg_read_bacth_exec_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      message.data.forEach(function (data) {
        var running = s.isForceAtlas2Running();
        setTimeout(function () {
          if (message.refresh === true && running === true) {
            s.killForceAtlas2();
          }
          s.graph.read(data);
          if (message.refresh === true) s.refresh();
          if (message.refresh === true && running === true) {
            s.startForceAtlas2();
          }
        }, data.nodes[0].delay);
      });
    }
  });

  // animate
  Shiny.addCustomMessageHandler("sg_animate_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      setTimeout(function () {
        sigma.plugins.animate(s, message.mapping, message.options);
      }, message.delay);
    }
  });

  // noverlap
  Shiny.addCustomMessageHandler("sg_noverlap_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      var listener_proxy = s.configNoverlap(message.config);
      s.startNoverlap();
    }
  });

  // export
  Shiny.addCustomMessageHandler("sg_export_svg_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      var output = s.toSVG(message.data);
    }
  });

  Shiny.addCustomMessageHandler("sg_export_img_p", function (message) {
    var r = get_sigma_renderer(message.id);
    if (typeof r != "undefined") {
      r.snapshot(message.data);
    }
  });

  Shiny.addCustomMessageHandler("sg_zoom_p", function (message) {
    var s = get_sigma_graph(message.id);
    if (typeof s != "undefined") {
      let n = s.graph.nodes()[message.node];
      sigma.misc.animation.camera(
        s.camera,
        {
          x: n[s.camera.readPrefix + "x"],
          y: n[s.camera.readPrefix + "y"],
          ratio: message.ratio,
        },
        { duration: message.duration }
      );
    }
  });

  Shiny.addCustomMessageHandler("sg_get_nodes_p", function (message) {
    var s = get_sigma_graph(message.id);
    var id = get_sigma_element(message.id);
    if (typeof s != "undefined") {
      Shiny.setInputValue(id + "_nodes" + ":sigmajsParseJS", s.graph.nodes(), {
        priority: "event",
      });
    }
  });

  Shiny.addCustomMessageHandler("sg_get_edges_p", function (message) {
    var s = get_sigma_graph(message.id);
    var id = get_sigma_element(message.id);
    if (typeof s != "undefined") {
      Shiny.setInputValue(id + "_edges" + ":sigmajsParseJS", s.graph.edges(), {
        priority: "event",
      });
    }
  });

  // change node attributes
  Shiny.addCustomMessageHandler("sg_change_nodes_p", function (message) {
    var s = get_sigma_graph(message.id);
    var i = 0;
    if (typeof s != "undefined") {
      setTimeout(function () {
        s.graph.nodes().forEach((n) => {
          n[message.message.attribute] = message.message.value[i];
          if (
            message.message.refresh === true &&
            message.message.rate === "iteration"
          ) {
            s.refresh();
          }
          i = i + 1;
        });

        if (
          message.message.refresh === true &&
          message.message.rate === "once"
        ) {
          s.refresh();
        }
      }, message.delay);
    }
  });

  Shiny.addCustomMessageHandler("sg_change_edges_p", function (message) {
    var s = get_sigma_graph(message.id);
    var i = 0;
    if (typeof s != "undefined") {
      setTimeout(function () {
        s.graph.edges().forEach((n) => {
          n[message.message.attribute] = message.message.value[i];
          if (
            message.message.refresh === true &&
            message.message.rate === "iteration"
          ) {
            s.refresh();
          }
          i = i + 1;
        });

        if (
          message.message.refresh === true &&
          message.message.rate === "once"
        ) {
          s.refresh();
        }
      }, message.delay);
    }
  });

  // filter greater than
  Shiny.addCustomMessageHandler("sg_filter_gt_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      if (message.target === "both") {
        filter
          .nodesBy(function (n) {
            return n[message.var] > message.input;
          }, message.name[0])
          .edgesBy(function (e) {
            return e[message.var] > message.input;
          }, message.name[1])
          .apply();
      } else if (message.target === "nodes") {
        filter
          .nodesBy(function (n) {
            return n[message.var] > message.input;
          }, message.name)
          .apply();
      } else {
        filter
          .edgesBy(function (e) {
            return e[message.var] > message.input;
          }, message.name)
          .apply();
      }
    }
  });

  // filter less than
  Shiny.addCustomMessageHandler("sg_filter_lt_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      if (message.target === "both") {
        filter
          .nodesBy(function (n) {
            return n[message.var] < message.input;
          }, message.name[0])
          .edgesBy(function (e) {
            return e[message.var] < message.input;
          }, message.name[1])
          .apply();
      } else if (message.target === "nodes") {
        filter
          .nodesBy(function (n) {
            return n[message.var] < message.input;
          }, message.name)
          .apply();
      } else {
        filter
          .edgesBy(function (e) {
            return e[message.var] < message.input;
          }, message.name)
          .apply();
      }
    }
  });

  // filter equal
  Shiny.addCustomMessageHandler("sg_filter_eq_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      if (message.target === "both") {
        filter
          .nodesBy(function (n) {
            return n[message.var] == message.input;
          }, message.name[0])
          .edgesBy(function (e) {
            return e[message.var] == message.input;
          }, message.name[1])
          .apply();
      } else if (message.target === "nodes") {
        filter
          .nodesBy(function (n) {
            return n[message.var] == message.input;
          }, message.name)
          .apply();
      } else {
        filter
          .edgesBy(function (e) {
            return e[message.var] == message.input;
          }, message.name)
          .apply();
      }
    }
  });

  // filter not equal
  Shiny.addCustomMessageHandler("sg_filter_not_eq_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      if (message.target === "both") {
        filter
          .nodesBy(function (n) {
            return n[message.var] != message.input;
          }, message.name[0])
          .edgesBy(function (e) {
            return e[message.var] != message.input;
          }, message.name[1])
          .apply();
      } else if (message.target === "nodes") {
        filter
          .nodesBy(function (n) {
            return n[message.var] != message.input;
          }, message.name)
          .apply();
      } else {
        filter
          .edgesBy(function (e) {
            return e[message.var] != message.input;
          }, message.name)
          .apply();
      }
    }
  });

  // filter undo
  Shiny.addCustomMessageHandler("sg_filter_undo_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      filter.undo(message.name).apply();
    }
  });

  // filter neighbours
  Shiny.addCustomMessageHandler("sg_filter_neighbours_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      var filter = new sigma.plugins.filter(s);

      filter.neighborsOf(message.node, message.name).apply();
    }
  });

  // set neightbours highlight
  Shiny.addCustomMessageHandler("sg_neighbours_p", function (message) {
    var s = get_sigma_graph(message.id);

    if (typeof s != "undefined") {
      db = new sigma.plugins.neighborhoods();

      s.graph.nodes().forEach(function (n) {
        n.originalColor = n.color;
      });
      s.graph.edges().forEach(function (e) {
        e.originalColor = e.color;
      });
      var nodeHasBeenClicked = false;
      // message.on can be "clickNode", "overNode" or "clickNode|overNode",
      // which means neighbour highlighting is triggered by both click and hover.
      // Bind on all events provided, potentially separated by "|":
      message.on.split("|").forEach(function (on) {
        s.bind(on, function (e) {
          if (on == "overNode" && nodeHasBeenClicked) {
            // do not highlight another hovered node, we are locked by user clicking on a node
            return;
          }
          var nodeId = e.data.node.id;
          if (on == "clickNode") {
            nodeHasBeenClicked = true; // lock highlighting at this node
          }
          // -- Finding connected nodes --
          // start by selecting all edges between nodeId and other nodes:
          var neighborEdges = s.graph.adjacentEdges(nodeId); // .toString()
          // keep only *visible* (not 'hidden') edges:
          neighborEdges = neighborEdges.filter(function (x) {
            return !x.hidden;
          });
          // extract the IDs of the connected nodes:
          var allIDs = neighborEdges
            .map(function (x) {
              return [x.source, x.target];
            })
            .flat();
          // deduplicate using an object:
          var toKeep = {};
          for (let id of allIDs) {
            toKeep[id] = true;
          }
          // done.
          // --
          s.graph.nodes().forEach(function (n) {
            if (toKeep[n.id]) n.color = n.originalColor;
            else n.color = message.nodes;
          });
          s.graph.edges().forEach(function (e) {
            // highlight all edges of connected nodes:
            // if (toKeep[e.source] && toKeep[e.target])
            // only highlight edges connected to the selected node:
            if (
              (toKeep[e.source] && e.target == nodeId) ||
              (e.source == nodeId && toKeep[e.target])
            )
              e.color = e.originalColor;
            else e.color = message.edges;
          });
          s.refresh();
        });
      });
      message.on.split("|").forEach(function (on) {
        on = on == "overNode" ? "outNode" : "clickStage";
        s.bind(on, function (e) {
          if (on == "outNode" && nodeHasBeenClicked) {
            // do not stop highlighting on mouse out, we are locked into highlighting by user clicking
            return;
          }
          if (on == "clickStage") {
            if (e.data.captor.isDragging) {
              return; // ignore clicks while dragging
            }
            nodeHasBeenClicked = false; // stop locking of highlighting
          }
          s.graph.nodes().forEach(function (n) {
            n.color = n.originalColor;
          });
          s.graph.edges().forEach(function (e) {
            e.color = e.originalColor;
          });
          s.refresh();
        });
      });
    }
  });
}
