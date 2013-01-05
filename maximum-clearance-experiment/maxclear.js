// Generated by CoffeeScript 1.4.0
(function() {

  Object.size = function(obj) {
    var key, size;
    size = 0;
    key = void 0;
    for (key in obj) {
      if (obj.hasOwnProperty(key)) {
        size++;
      }
    }
    return size;
  };

  $(function() {
    var $img;
    $img = $("<img>", {
      src: "wheel_v.png"
    });
    $img.load(function() {
      $('#source')[0].width = this.height;
      $('#source')[0].height = this.height;
      $('#source')[0].getContext('2d').drawImage(this, 0, 0, $('#source')[0].width, $('#source')[0].height);
      window.maxClearance = new MaxClearance($('#source')[0], $('#main')[0]);
      return window.maxClearance.compute();
    });
    $('#main').mousemove(function(e) {
      var xx, yy;
      xx = (e.offsetX - e.offsetX % window.maxClearance.unit) / window.maxClearance.unit;
      yy = (e.offsetY - e.offsetY % window.maxClearance.unit) / window.maxClearance.unit;
      return $('#value_watch').html(Object.size(window.maxClearance.V["" + (xx * window.maxClearance.unit) + "," + (yy * window.maxClearance.unit)].crossers));
    });
    return $('#main').click(function(e) {
      var context, scontext, shape, xx, yy;
      shape = document.createElement("canvas");
      shape.width = shape.height = 100;
      scontext = shape.getContext('2d');
      scontext.beginPath();
      scontext.arc(50, 50, 50, 0, 2 * Math.PI, false);
      scontext.fillStyle = 'green';
      scontext.fill();
      xx = (e.offsetX - e.offsetX % window.maxClearance.unit) / window.maxClearance.unit;
      yy = (e.offsetY - e.offsetY % window.maxClearance.unit) / window.maxClearance.unit;
      context = $('#source')[0].getContext('2d');
      context.globalCompositeOperation = "destination-out";
      context.drawImage(shape, e.offsetX - 50, e.offsetY - 50);
      return window.maxClearance.erase(shape, e.offsetX - 50, e.offsetY - 50);
    });
  });

  window.MaxClearance = (function() {
    var Vertex;

    MaxClearance.Direction = {
      eastBound: 1,
      westBound: -1
    };

    MaxClearance.Where = {
      upper: 0,
      self: 1,
      lower: 2
    };

    function MaxClearance(sourceCanvasEl, destCanvasEl) {
      this.source = sourceCanvasEl;
      this.main = destCanvasEl;
      this.sourceContext = this.source.getContext('2d');
      this.mainContext = this.main.getContext('2d');
      this.main.width = this.source.width;
      this.main.height = this.source.height;
      this.data = this.sourceContext.getImageData(0, 0, main.width, main.height).data;
      this.unit = 5;
      this.V = {};
    }

    MaxClearance.prototype.erase = function(shape, topLeftX, topLeftY) {
      var data, x, y;
      data = shape.getContext('2d').getImageData(0, 0, shape.width, shape.height).data;
      x = topLeftX + this.unit - topLeftX % this.unit;
      while (x < topLeftX + shape.width) {
        y = topLeftY + this.unit - topLeftY % this.unit;
        while (y < topLeftY + shape.height) {
          this.erasePointAt(x, y);
          y += this.unit;
        }
        x += this.unit;
      }
      return this.printGradientMap();
    };

    MaxClearance.prototype.erasePointAt = function(x, y) {
      var index, k, newDist, v, v0, _ref, _results;
      v = this.V["" + x + "," + y];
      v.alpha = 0;
      this.distData[v.x / this.unit + v.y / this.unit * Math.round(this.main.width / this.unit)] = 0;
      _ref = v.crossers;
      _results = [];
      for (k in _ref) {
        v0 = _ref[k];
        delete v.crossers[k];
        newDist = this.distance(x, y, v0.x, v0.y);
        index = v0.x / this.unit + v0.y / this.unit * Math.round(this.main.width / this.unit);
        if (this.distData[index] > newDist) {
          _results.push(this.distData[index] = newDist);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    MaxClearance.prototype.getAlpha = function(x, y) {
      var v;
      return v = this.data[(y * main.width + x) * 4 + 3];
    };

    MaxClearance.prototype.compute = function() {
      this.reach = [];
      this.distData = new Uint32Array(Math.round(this.main.width / this.unit) * Math.round(this.main.height));
      this.maxdist = 0;
      this.sweep(MaxClearance.Direction.eastBound);
      this.sweep(MaxClearance.Direction.westBound);
      this.updateCrossers();
      this.printBoundaries();
      return this.printGradientMap();
    };

    MaxClearance.prototype.sweep = function(direction) {
      var alpha, dist, entered_range, in_range, index, minBorderDist, nn, pos, v, v0, vj, vk, where, xc, y, _i, _len, _ref, _results;
      this.A = [];
      xc = direction > 0 ? 0 : main.width - main.width % this.unit;
      nn = direction > 0 ? main.width : 0;
      _results = [];
      while (xc * direction < nn) {
        y = 0;
        while (y < main.height) {
          alpha = this.getAlpha(xc, y);
          v = new Vertex(xc, y);
          this.V[v.key] = v;
          v.alpha = alpha;
          this.A[y / this.unit] = v;
          y += this.unit;
        }
        _ref = this.A;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vj = _ref[_i];
          if (vj.alpha === 0 && !vj.isSubsumed() && !vj.isSelected()) {
            if (!this.begin) {
              this.begin = this.end = vj;
              vj.setSelected();
            } else {
              in_range = true;
              entered_range = false;
              pos = void 0;
              where = void 0;
              vk = this.end;
              while (vk) {
                if (!vk.isSubsumed()) {
                  y = vj.getIntersectionY(vk, xc);
                  if (vj.y > vk.y) {
                    if (y < vk.lowerBound) {
                      pos = this.subsume(vk, vj);
                      where = MaxClearance.Where.self;
                      if (!entered_range) {
                        entered_range = true;
                      }
                    } else if (y < vk.upperBound) {
                      pos = vk;
                      where = MaxClearance.Where.upper;
                      this.updateBounds(vj, xc);
                      if (!entered_range) {
                        entered_range = true;
                      }
                    } else if (entered_range) {
                      break;
                    }
                  } else if (vj.y === vk.y) {
                    pos = this.subsume(vk, vj);
                    where = MaxClearance.Where.self;
                    if (!entered_range) {
                      entered_range = true;
                    }
                  } else {
                    if (y > vk.upperBound) {
                      pos = this.subsume(vk, vj);
                      where = MaxClearance.Where.self;
                      if (!entered_range) {
                        entered_range = true;
                      }
                    } else if (y > vk.lowerBound) {
                      pos = vk;
                      where = MaxClearance.Where.lower;
                      if (!entered_range) {
                        entered_range = true;
                      }
                    } else if (entered_range) {
                      break;
                    }
                  }
                }
                vk = vk.lowerVertex;
              }
              if (entered_range) {
                this.connect(pos, vj, where);
                this.updateBounds(vj, xc);
                vj.setSelected();
              }
            }
          }
        }
        if (this.begin) {
          y = 0;
          v = this.begin;
          while (y < this.main.height) {
            if (y > v.upperBound && v.upperVertex) {
              v = v.upperVertex;
            }
            dist = this.distance(xc, y, v.x, v.y);
            minBorderDist = this.getMinBorderDistance(xc, y);
            if (minBorderDist < dist) {
              dist = minBorderDist;
            }
            if (dist > this.maxdist) {
              this.maxdist = dist;
            }
            index = xc / this.unit + y / this.unit * Math.round(main.width / this.unit);
            if (!this.distData[index] || this.distData[index] > dist) {
              this.distData[index] = dist;
            }
            v0 = this.V["" + xc + "," + y];
            console.assert(v0);
            this.reach[v0] = v;
            y += this.unit;
          }
        }
        _results.push(xc += direction * this.unit);
      }
      return _results;
    };

    MaxClearance.prototype.updateCrossers = function() {
      var index, v0, vd, xc, y, _results;
      xc = 0;
      _results = [];
      while (xc < this.main.width) {
        y = 0;
        while (y < this.main.height) {
          v0 = this.V["" + xc + "," + y];
          if (v0.alpha > 0) {
            index = xc / this.unit + y / this.unit * Math.round(main.width / this.unit);
            vd = this.reach[v0];
            this.addCrossers(v0, vd.x, vd.y);
          }
          y += this.unit;
        }
        _results.push(xc += this.unit);
      }
      return _results;
    };

    MaxClearance.prototype.addCrossers = function(v, x, y) {
      var dx, dy, e2, err, key, sx, sy, x0, y0, _results;
      x0 = v.x;
      y0 = v.y;
      dx = Math.abs(x - x0);
      dy = Math.abs(y - y0);
      if (x0 < x) {
        sx = this.unit;
      } else {
        sx = -this.unit;
      }
      if (y0 < y) {
        sy = this.unit;
      } else {
        sy = -this.unit;
      }
      err = dx - dy;
      _results = [];
      while (true) {
        key = "" + x0 + "," + y0;
        this.V[key].crossers["" + v.x + "," + v.y] = v;
        if (x0 === x && y0 === y) {
          break;
        }
        e2 = 2 * err;
        if (e2 > -dy) {
          err -= dy;
          x0 += sx;
        }
        if (e2 < dx) {
          err += dx;
          _results.push(y0 += sy);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    MaxClearance.prototype.getMinBorderDistance = function(x, y) {
      var minXBorderDist, minYBorderDist;
      if (x > this.main.width / 2) {
        minXBorderDist = this.main.width - x;
      } else {
        minXBorderDist = x;
      }
      if (y > this.main.height / 2) {
        minYBorderDist = this.main.height - y;
      } else {
        minYBorderDist = y;
      }
      if (minXBorderDist < minYBorderDist) {
        return minXBorderDist;
      } else {
        return minYBorderDist;
      }
    };

    MaxClearance.prototype.printBoundaries = function() {
      var xc, _results;
      xc = 0;
      _results = [];
      while (xc < main.width) {
        _results.push(xc++);
      }
      return _results;
    };

    MaxClearance.prototype.printGradientMap = function() {
      var val, xc, xx, y, yy, _results;
      this.mainContext.clearRect(0, 0, this.main.width, this.main.height);
      xc = 0;
      _results = [];
      while (xc < main.width) {
        y = 0;
        while (y < this.main.height) {
          xx = (xc - xc % this.unit) / this.unit;
          yy = (y - y % this.unit) / this.unit;
          val = 255 - Math.round(this.distData[xx + yy * Math.round(main.width / this.unit)] / this.maxdist * 255);
          this.mainContext.fillStyle = "rgba(255," + val + ",255,1)";
          this.mainContext.fillRect(xc, y, this.unit, this.unit);
          y += this.unit;
        }
        _results.push(xc += this.unit);
      }
      return _results;
    };

    MaxClearance.prototype.updateBounds = function(v, xc) {
      if (v.upperVertex) {
        v.upperVertex.lowerBound = v.upperBound = v.getIntersectionY(v.upperVertex, xc);
      }
      if (v.lowerVertex) {
        return v.lowerVertex.upperBound = v.lowerBound = v.getIntersectionY(v.lowerVertex, xc);
      }
    };

    MaxClearance.prototype.connect = function(pos, v, where) {
      switch (where) {
        case MaxClearance.Where.upper:
          if (pos.upperVertex) {
            pos.upperVertex.lowerVertex = v;
            v.upperVertex = pos.upperVertex;
          }
          pos.upperVertex = v;
          v.lowerVertex = pos;
          if (this.end === pos) {
            return this.end = v;
          }
          break;
        case MaxClearance.Where.self:
          if (pos.upperVertex) {
            pos.upperVertex.lowerVertex = v;
            v.upperVertex = pos.upperVertex;
          }
          if (pos.lowerVertex) {
            pos.lowerVertex.upperVertex = v;
            return v.lowerVertex = pos.lowerVertex;
          }
          break;
        case MaxClearance.Where.lower:
          if (pos.lowerVertex) {
            pos.lowerVertex.upperVertex = v;
            v.lowerVertex = pos.lowerVertex;
          }
          pos.lowerVertex = v;
          v.upperVertex = pos;
          if (this.begin === pos) {
            return this.begin = v;
          }
      }
    };

    MaxClearance.prototype.distance = function(x1, y1, x2, y2) {
      return Math.sqrt(Math.pow(y2 - y1, 2) + Math.pow(x2 - x1, 2));
    };

    MaxClearance.prototype.subsume = function(vk, vj) {
      vk.setSubsumed();
      if (vk.upperVertex) {
        vk.upperVertex.lowerVertex = vk.lowerVertex;
      }
      if (vk.lowerVertex) {
        vk.lowerVertex.upperVertex = vk.upperVertex;
      }
      vj.upperBound = vk.upperBound;
      vj.lowerBound = vk.lowerBound;
      if (this.begin === vk) {
        this.begin = vj;
      }
      if (this.end === vk) {
        this.end = vj;
      }
      return vk;
    };

    MaxClearance.prototype.printStack = function() {
      var s, v;
      s = "";
      v = this.begin;
      while (v) {
        if (v && !v.isSubsumed()) {
          s += v.toString() + ", ";
        }
        v = v.upperVertex;
      }
      return console.log(s);
    };

    MaxClearance.prototype.distanceInfo = [];

    Vertex = (function() {

      function Vertex(x, y) {
        this.x = x;
        this.y = y;
        this.key = "" + x + "," + y;
        this.upperBound = 1.7976931348623157e10308;
        this.lowerBound = -1.7976931348623157e10308;
        this.upperVertex = void 0;
        this.lowerVertex = void 0;
        this.crossers = {};
      }

      Vertex.prototype.getIntersectionY = function(vertex, x) {
        var atanRatio, midX, midY, y;
        midY = (vertex.y + this.y) / 2;
        if (vertex.x === this.x) {
          y = midY;
        } else {
          midX = (vertex.x + this.x) / 2;
          atanRatio = (vertex.y - this.y) / (vertex.x - this.x);
          y = midY - (x - midX) / atanRatio;
        }
        return y;
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

      Vertex.prototype.setSubsumed = function() {
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
