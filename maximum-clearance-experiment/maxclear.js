// Generated by CoffeeScript 1.4.0
(function() {

  $(function() {
    var $img;
    $img = $("<img>", {
      src: "test.png"
    });
    return $img.load(function() {
      $('#source')[0].width = this.height;
      $('#source')[0].height = this.height;
      $('#source')[0].getContext('2d').drawImage(this, 0, 0, $('#source')[0].width, $('#source')[0].height);
      window.maxClearance = new MaxClearance($('#source')[0], $('#main')[0]);
      return window.maxClearance.compute();
    });
  });

  Array.prototype.nearestVertex = function(v) {
    return this[0];
  };

  window.MaxClearance = (function() {
    var Vertex;

    function MaxClearance(sourceCanvasEl, destCanvasEl) {
      this.source = sourceCanvasEl;
      this.main = destCanvasEl;
      this.sourceContext = this.source.getContext('2d');
      this.mainContext = this.main.getContext('2d');
      this.main.width = this.source.width;
      this.main.height = this.source.height;
      this.data = this.sourceContext.getImageData(0, 0, main.width, main.height).data;
    }

    MaxClearance.prototype.getAlpha = function(x, y) {
      var v;
      return v = this.data[(y * main.width + x) * 4 + 3];
    };

    MaxClearance.prototype.compute = function() {
      var alpha, entered_range, i, in_range, insert_pos, k, n, newVertices, v, vj, vk, xc, y, _i, _j, _len, _ref, _results;
      n = main.width;
      this.A = [];
      this.partitions = [1.7976931348623157e10308, -1.7976931348623157e10308];
      this.stack = [];
      while (i < n) {
        this.stack[i] = void 0;
        i++;
      }
      this.distData = new Uint32Array(this.main.width * this.main.height);
      this.maxdist = Math.sqrt(Math.pow(this.main.width, 2) + Math.pow(this.main.height, 2));
      i = 0;
      xc = 0;
      _results = [];
      while (xc < n) {
        y = 0;
        newVertices = [];
        while (y < n) {
          alpha = this.getAlpha(xc, y);
          if (alpha > 0) {
            v = new Vertex(xc, y);
            v.alpha = alpha;
            this.A[y] = v;
            newVertices.push(v);
          }
          y++;
        }
        for (_i = 0, _len = newVertices.length; _i < _len; _i++) {
          vj = newVertices[_i];
          if (!this.stack.length) {
            this.stack.push(vj);
            vj.setSelected();
          } else {
            in_range = true;
            entered_range = false;
            insert_pos = void 0;
            for (k = _j = _ref = this.stack.length - 1; _j >= 0; k = _j += -1) {
              vk = this.stack[k];
              if (vk && !vk.isSubsumed()) {
                y = vj.getIntersectionY(vk, xc, MaxClearance.Direction.eastBound);
                if (vj.y > vk.y) {
                  if (y < vk.lowerBound) {
                    insert_pos = this.subsume(k, vj);
                    if (!entered_range) {
                      entered_range = true;
                    }
                  } else if (y < vk.upperBound) {
                    this.connect(vj, vk, y);
                    insert_pos = vj.y;
                    if (!entered_range) {
                      entered_range = true;
                    }
                  } else if (entered_range) {
                    break;
                  }
                } else if (vj.y === vk.y) {
                  insert_pos = this.subsume(k, vj);
                  if (!entered_range) {
                    entered_range = true;
                  }
                } else {
                  if (y > vk.upperBound) {
                    insert_pos = this.subsume(k, vj);
                    if (!entered_range) {
                      entered_range = true;
                    }
                  } else if (y > vk.lowerBound) {
                    this.connect(vk, vj, y);
                    insert_pos = vj.y;
                    if (!entered_range) {
                      entered_range = true;
                    }
                  } else if (entered_range) {
                    break;
                  }
                }
              }
            }
            if (entered_range) {
              console.assert(insert_pos !== void 0);
              console.assert(this.stack[insert_pos] === void 0 || this.stack[insert_pos].isSubsumed());
              this.stack[insert_pos] = vj;
              vj.setSelected();
            }
          }
        }
        y = 0;
        while (y < n) {
          v = this.stack[y];
          if (v) {
            this.mainContext.beginPath();
            this.mainContext.rect(xc, v.lowerBound, 1, 1);
            this.mainContext.rect(xc, v.upperBound, 1, 1);
            this.mainContext.stroke();
          }
          y++;
        }
        _results.push(xc++);
      }
      return _results;
    };

    MaxClearance.Direction = {
      eastBound: 0,
      westBound: 1
    };

    MaxClearance.prototype.distance = function(x1, y1, x2, y2) {
      return Math.sqrt(Math.pow(y2 - y1) + Math.pow(x2 - x1));
    };

    MaxClearance.prototype.subsume = function(k, vj) {
      var vk;
      vk = this.stack[k];
      vk.setSubsumed();
      this.stack[k] = void 0;
      return vj.y;
    };

    MaxClearance.prototype.printStack = function() {
      var s, v, _i, _len, _ref;
      s = "";
      _ref = this.stack;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        v = _ref[_i];
        if (v && !v.isSubsumed()) {
          s += v.toString() + ", ";
        }
      }
      return console.log(s);
    };

    MaxClearance.prototype.connect = function(upper, lower, y) {
      upper.lowerVertex = lower;
      lower.upperVertex = upper;
      return lower.upperBound = upper.lowerBound = y;
    };

    MaxClearance.prototype.distanceInfo = [];

    Vertex = (function() {

      function Vertex(x, y) {
        this.x = x;
        this.y = y;
      }

      Vertex.prototype.upperBound = 1.7976931348623157e10308;

      Vertex.prototype.lowerBound = -1.7976931348623157e10308;

      Vertex.prototype.upperVertex = void 0;

      Vertex.prototype.lowerVertex = void 0;

      Vertex.prototype.getIntersectionY = function(vertex, x, direction) {
        var atanRatio, midX, midY, y;
        if (direction === MaxClearance.Direction.eastBound) {
          midY = (vertex.y + this.y) / 2;
          if (vertex.x === this.x) {
            y = midY;
          } else {
            midX = (vertex.x + this.x) / 2;
            atanRatio = (vertex.y - this.y) / (vertex.x - this.x);
            y = midY - (x - midX) / atanRatio;
          }
          return y;
        } else if (direction === MaxClearance.Direction.westBound) {
          return alert('not implemented');
        }
      };

      Vertex.prototype.isSubsumed = function() {
        if (this.subsumed) {
          return true;
        } else {
          return false;
        }
      };

      Vertex.prototype.isSelected = function() {
        if (this.selected) {
          return true;
        } else {
          return false;
        }
      };

      Vertex.prototype.setSubsumed = function(v) {
        console.assert(this.selected);
        this.subsumedBy = v;
        return this.subsumed = true;
      };

      Vertex.prototype.setSelected = function() {
        return this.selected = true;
      };

      Vertex.prototype.toString = function() {
        return "(" + this.x + "," + this.y + ")";
      };

      return Vertex;

    })();

    return MaxClearance;

  })();

}).call(this);
