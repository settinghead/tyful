package wordcram;

import java.awt.Graphics;
import java.awt.Polygon;
import java.awt.geom.Arc2D;
import java.util.ArrayList;

import processing.core.*;
import wordcram.BBPolarTree.BBPolarRootTree;

/*
 Copyright 2010 Daniel Bernier

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

abstract class BBPolarTree {

	static final float HALF_PI = (float) (Math.PI / 2);
	static final float TWO_PI = (float) (Math.PI * 2);
	static final float PI = (float) Math.PI;
	static final float ONE_AND_HALF_PI = (float) (Math.PI + HALF_PI);

	public static class BBPolarRootTree extends BBPolarTree {
		private int rootX;
		private int rootY;
		private float _rotation = 0;

		public BBPolarRootTree(int centerX, int centerY, float d) {
			super(0, TWO_PI, 0, d);
			this.rootX = centerX;
			this.rootY = centerY;
		}

		@Override
		void setLocation(int centerX, int centerY) {
			this.rootX = centerX;
			this.rootY = centerY;
		}

		@Override
		int getRootX() {
			return rootX;
		}

		@Override
		int getRootY() {
			return rootY;
		}

		@Override
		protected float getX() {
			return (float) -super.d2;
		}

		@Override
		protected float getY() {
			return (float) -super.d2;
		}

		@Override
		protected float getRight() {
			return (float) super.d2;
		}

		@Override
		protected float getBottom() {
			return (float) super.d2;
		}

		@Override
		public void setRotation(float rotation) {
			this._rotation = rotation;
			this.resetComputedRs();
		}

		@Override
		public float getRotation() {
			return this._rotation;
		}

		@Override
		protected void resetComputedRs() {
			for (BBPolarTree kid : this.kids)
				kid.resetComputedRs();
		}

	}

	public static class BBPolarChildTree extends BBPolarTree {

		BBPolarRootTree root;

		private float _x = Integer.MIN_VALUE, _y = Integer.MIN_VALUE,
				_right = Integer.MIN_VALUE, _bottom = Integer.MIN_VALUE;

		BBPolarChildTree(float r1, float r2, float d1, float d2,
				BBPolarRootTree root) {
			super(r1, r2, d1, d2);
			this.root = root;
		}

		@Override
		void setLocation(int centerX, int centerY) {
			root.setLocation(centerX, centerY);
		}

		@Override
		int getRootX() {
			return root.getRootX();
		}

		@Override
		int getRootY() {
			return root.getRootY();
		}

		@Override
		protected float getX() {
			if (_x == Integer.MIN_VALUE) {
				if (getR1() < HALF_PI) {
					if (getR2() < getR1()) {
						_x = (float) (d2 * Math.cos(PI));
					} else if (getR2() < HALF_PI) {
						_x = (float) (d1 * Math.cos(getR2()));
					} else if (getR2() < PI) {
						_x = (float) (d2 * Math.cos(getR2()));
					} else {
						// circle
						_x = (float) (d2 * Math.cos(PI));
					}
				} else if (getR1() < PI) {
					if (getR2() < HALF_PI) {
						_x = (float) (d2 * Math.cos(PI));
					} else if (getR2() < PI) {
						_x = (float) (d2 * Math.cos(getR2()));
					} else if (getR2() < ONE_AND_HALF_PI) {
						_x = (float) (d2 * Math.cos(PI));
					} else {
						_x = (float) (d2 * Math.cos(PI));
					}
				} else if (getR1() < ONE_AND_HALF_PI) {
					if (getR2() < HALF_PI) {
						_x = (float) (d2 * Math.cos(getR1()));
					} else if (getR2() < getR1()) {
						float x1 = (float) (d2 * Math.cos(getR1()));
						float x2 = (float) (d2 * Math.cos(getR2()));
						_x = x1 < x2 ? x1 : x2;
					} else if (getR2() < ONE_AND_HALF_PI) {
						_x = (float) (d2 * Math.cos(getR1()));
					} else {
						_x = (float) (d2 * Math.cos(getR1()));
					}
				} else {
					if (getR2() < HALF_PI) {
						float x1 = (float) (d1 * Math.cos(getR1()));
						float x2 = (float) (d1 * Math.cos(getR2()));
						_x = x1 < x2 ? x1 : x2;
					} else if (getR2() < PI) {
						_x = (float) (d2 * Math.cos(getR2()));
					} else if (getR2() < getR1()) {
						_x = (float) (d2 * Math.cos(PI));
					} else
						_x = (float) (d1 * Math.cos(getR1()));
				}
			}
			return _x;
		}

		@Override
		protected float getY() {
			if (_y == Integer.MIN_VALUE) {
				if (getR1() < HALF_PI) {
					if (getR2() < getR1()) {
						_y = (float) (d1 * Math.sin(HALF_PI));
					} else if (getR2() < HALF_PI) {
						_y = (float) (d2 * Math.sin(getR2()));
					} else if (getR2() < PI) {
						_y = (float) (d2 * Math.sin(HALF_PI));
					} else {
						// circle
						_y = (float) (d2 * Math.sin(HALF_PI));
					}
				} else if (getR1() < PI) {
					if (getR2() < HALF_PI) {
						float y1 = (float) (d2 * Math.sin(getR1()));
						float y2 = (float) (d2 * Math.sin(getR2()));
						_y = y1 > y2 ? y1 : y2;
					} else if (getR1() < getR2())
						_y = (float) (d2 * Math.sin(HALF_PI));
					else
						_y = (float) (d2 * Math.sin(getR1()));
				} else if (getR1() < ONE_AND_HALF_PI) {
					if (getR2() < PI) {
						_y = (float) (d2 * Math.sin(HALF_PI));
					} else if (getR2() < getR1()) {
						_y = (float) (d1 * Math.sin(getR2()));
					} else if (getR2() < ONE_AND_HALF_PI) {
						_y = (float) (d1 * Math.sin(getR1()));
					} else {
						float val1 = (float) (d1 * Math.sin(getR2()));
						float val2 = (float) (d1 * Math.sin(getR1()));
						_y = val1 > val2 ? val1 : val2;
					}

				} else {
					if (getR2() < HALF_PI) {
						_y = (float) (d2 * Math.sin(getR2()));
					} else if (getR2() < getR1()) {
						_y = (float) (d2 * Math.sin(HALF_PI));
					} else
						_y = (float) (d1 * Math.sin(getR2()));
				}
				_y = -_y;

			}
			return _y;
		}

		@Override
		protected float getRight() {
			if (_right == Integer.MIN_VALUE) {

				if (getR1() < HALF_PI) {
					if (getR2() < getR1()) {
						_right = (float) (d2 * Math.cos(0));
					} else if (getR2() < HALF_PI) {
						_right = (float) (d2 * Math.cos(getR1()));
					} else if (getR2() < PI) {
						_right = (float) (d2 * Math.cos(getR1()));
					} else {
						// circle
						_right = (float) (d2 * Math.cos(0));
					}
				} else if (getR1() < PI) {
					if (getR2() < getR1()) {
						_right = (float) (d2 * Math.cos(0));
					} else if (getR2() < PI) {
						_right = (float) (d1 * Math.cos(getR1()));
					} else if (getR2() < ONE_AND_HALF_PI) {
						float val1 = (float) (d1 * Math.cos(getR1()));
						;
						float val2 = (float) (d1 * Math.cos(getR2()));
						;
						_right = val1 > val2 ? val1 : val2;
					} else {
						_right = (float) (d2 * Math.cos(getR2()));
					}
				} else if (getR1() < ONE_AND_HALF_PI) {
					if (getR2() < getR1()) {
						_right = (float) (d2 * Math.cos(0));
					}
					if (getR2() < ONE_AND_HALF_PI) {
						_right = (float) (d1 * Math.cos(getR2()));
					} else {
						_right = (float) (d2 * Math.cos(getR2()));
					}

				} else {
					if (getR2() < getR1()) {
						_right = (float) (d2 * Math.cos(0));
					} else
						_right = (float) (d2 * Math.cos(getR2()));
				}
			}
			return _right;
		}

		@Override
		protected float getBottom() {
			if (_bottom == Integer.MIN_VALUE) {
				if (getR1() < HALF_PI) {
					if (getR2() < getR1()) {
						_bottom = (float) (d1 * Math.sin(ONE_AND_HALF_PI));
					} else if (getR2() < HALF_PI) {
						_bottom = (float) (d1 * Math.sin(getR1()));
					} else if (getR2() < PI) {
						float val1 = (float) (d1 * Math.sin(getR1()));
						float val2 = (float) (d1 * Math.sin(getR2()));
						_bottom = val1 < val2 ? val1 : val2;
					} else {
						// circle
						_bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
					}
				} else if (getR1() < PI) {
					if (getR2() < getR1()) {
						_bottom = (float) (d1 * Math.sin(ONE_AND_HALF_PI));
					}
					if (getR2() < PI) {
						_bottom = (float) (d1 * Math.sin(getR2()));
					} else if (getR2() < ONE_AND_HALF_PI) {
						_bottom = (float) (d2 * Math.sin(getR2()));
					} else {
						_bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
					}
				} else if (getR1() < ONE_AND_HALF_PI) {
					if (getR2() < getR1()) {
						_bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
					} else if (getR2() < ONE_AND_HALF_PI) {
						_bottom = (float) (d2 * Math.sin(getR2()));
					} else {
						_bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
					}

				} else {
					if (getR2() < PI) {
						_bottom = (float) (d2 * Math.sin(getR1()));
					} else if (getR2() < ONE_AND_HALF_PI) {
						float b1 = (float) (d2 * Math.sin(getR1()));
						float b2 = (float) (d2 * Math.sin(getR2()));
						_bottom = b1 < b2 ? b1 : b2;
					} else if (getR2() < getR1()) {
						_bottom = (float) Math.cos(ONE_AND_HALF_PI);
					} else
						_bottom = (float) (d2 * Math.sin(getR1()));
				}
				_bottom = -_bottom;

			}
			return _bottom;
		}

		@Override
		public void setRotation(float rotation) {
			this.root.setRotation(rotation);
		}

		@Override
		public float getRotation() {
			return root.getRotation();
		}

		@Override
		protected void resetComputedRs() {

			this._computedR2 = this._computedR1 = Float.NaN;
			this._x = this._y = this._bottom = this._right = Integer.MIN_VALUE;
			if (kids != null)
				for (BBPolarTree child : kids)
					child.resetComputedRs();

		}
	}

	protected float _r1, d1, _r2, d2, r;
	protected BBPolarTree[] kids;
	private float[] _points;
	protected float _computedR1 = Float.NaN, _computedR2 = Float.NaN;

	BBPolarTree(float r1, float r2, float d1, float d2) {
		this._r1 = r1;
		this._r2 = r2;
		this.d1 = d1;
		this.d2 = d2;
	}

	void addKids(BBPolarTree... _kids) {
		ArrayList<BBPolarTree> kidList = new ArrayList<BBPolarTree>();
		for (BBPolarTree kid : _kids) {
			if (kid != null) {
				kidList.add(kid);
			}
		}
		kids = kidList.toArray(new BBPolarTree[0]);
	}

	abstract void setLocation(int x, int y);

	abstract int getRootX();

	abstract int getRootY();

	boolean overlaps(BBPolarTree otherTree) {

		if (this.rectCollide(otherTree)) {
			if (this.isLeaf() && otherTree.isLeaf()) {
				return true;
			} else if (this.isLeaf()) { // Then otherTree isn't a leaf.
				for (BBPolarTree otherKid : otherTree.kids) {
					if (this.overlaps(otherKid)) {
						return true;
					}
				}
			} else {
				for (BBPolarTree myKid : this.kids) {
					if (otherTree.overlaps(myKid)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	boolean overlaps(float x, float y, float right, float bottom) {

		if (this.rectCollide(x, y, right, bottom)) {
			if (this.isLeaf()) {
				return true;
			} else {
				for (BBPolarTree myKid : this.kids) {
					if (myKid.overlaps(x, y, right, bottom)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public boolean contains(float x, float y, float right, float bottom) {

		if (this.rectContain(x, y, right, bottom)) {
			if (this.isLeaf())
				return true;
			else {
				for (BBPolarTree myKid : this.kids) {
					if (myKid.contains(x, y, right, bottom)) {
						return true;
					}
				}
				return false;
			}
		} else
			return false;
	}

	protected abstract float getX();

	protected abstract float getY();

	protected abstract float getRight();

	protected abstract float getBottom();

	public float getR1() {
		if (Float.isNaN(this._computedR1)) {
			_computedR1 = this._r1 + getRotation();
			if (_computedR1 > TWO_PI)
				this._computedR1 = (_computedR1) % TWO_PI;
		}
		return this._computedR1;
	}

	public float getR2() {
		if (Float.isNaN(this._computedR2)) {
			this._computedR2 = this._r2 + getRotation();
			if (this._computedR2 > TWO_PI)
				this._computedR2 = (_computedR2) % TWO_PI;
		}
		return this._computedR2;
	}

	private float[] getPoints() {
		// if (this._points == null)
		this._points = new float[] { getRootX() - swelling + getX(),
				getRootY() - swelling + getY(),
				getRootX() + swelling + getRight(),
				getRootY() + swelling + getBottom() };
		return this._points;
	}

	private boolean rectCollide(BBPolarTree bTree) {
		float[] b = bTree.getPoints();

		return rectCollide(b[0], b[1], b[2], b[3]);
	}

	private boolean rectContain(float x, float y, float right, float bottom) {
		float[] a = this.getPoints();
		return a[0] <= x && a[1] <= y && a[2] >= right && a[3] >= bottom;
	}

	private boolean rectCollide(float x, float y, float right, float bottom) {
		float[] a = this.getPoints();

		assert (a[0] < a[2]);
		assert (a[1] < a[3]);
		assert (x < right);
		assert (y < bottom);

		return a[3] > y && a[1] < bottom && a[2] > x && a[0] < right;
	}

	boolean isLeaf() {
		return kids == null;
	}

	int swelling = 0;

	void swell(int extra) {
		swelling += extra;
		if (!isLeaf()) {
			for (int i = 0; i < kids.length; i++) {
				kids[i].swell(extra);
			}
		}
	}

	void draw(PGraphics g) {
		g.pushStyle();
		g.noFill();

		g.stroke(30, 255, 255, 50);
		drawLeaves(g);

		g.popStyle();
	}

	void draw(Graphics g) {
		drawLeaves(g);

	}

	private void drawLeaves(Graphics g) {
		if (this.isLeaf()) {
			drawBounds(g, getPoints());
		} else {
			for (int i = 0; i < kids.length; i++) {
				kids[i].drawLeaves(g);
			}
		}
	}

	private void drawLeaves(PGraphics g) {
		if (this.isLeaf()) {
			drawBounds(g, getPoints());
		} else {
			for (int i = 0; i < kids.length; i++) {
				kids[i].drawLeaves(g);
			}
		}
	}

	private void drawBounds(PGraphics g, float[] rect) {
		g.rect(rect[0], rect[1], rect[2], rect[3]);
	}

	static int drawCount = 0;

	private void drawBounds(Graphics g, float[] rect) {
		int x1, x2, x3, x4, y1, y2, y3, y4;
		x1 = (int) (this.getRootX() + this.d1 * Math.cos(getR1()));
		y1 = (int) (this.getRootY() - this.d1 * Math.sin(getR1()));
		x2 = (int) (this.getRootX() + this.d1 * Math.cos(getR2()));
		y2 = (int) (this.getRootY() - this.d1 * Math.sin(getR2()));
		x3 = (int) (this.getRootX() + this.d2 * Math.cos(getR1()));
		y3 = (int) (this.getRootY() - this.d2 * Math.sin(getR1()));
		x4 = (int) (this.getRootX() + this.d2 * Math.cos(getR2()));
		y4 = (int) (this.getRootY() - this.d2 * Math.sin(getR2()));

		float r = this.getR2() - this.getR1();
		assert (r < PI);
		// Polygon p = new Polygon(new int[] { x1, x2, x3, x4 }, new int[] { y1,
		// y2, y3, y4 }, 4);

		// g.drawPolygon(p);
		g.drawArc((int) (this.getRootX() - this.d2),
				(int) (this.getRootY() - this.d2), (int) (this.d2 * 2),
				(int) (this.d2 * 2), (int) Math.toDegrees(this.getR1()),
				(int) Math.toDegrees(r) + 1);
		g.drawArc((int) (this.getRootX() - this.d1),
				(int) (this.getRootY() - this.d1), (int) (this.d1 * 2),
				(int) (this.d1 * 2), (int) Math.toDegrees(this.getR1()),
				(int) Math.toDegrees(r));
		g.drawLine(x1, y1, x3, y3);
		g.drawLine(x2, y2, x4, y4);
		// System.err.println(this.getWidth() + ", " + this.getHeight());
		// g.drawRect((int) (this.getRootX() + this.getX()),
		// (int) (this.getRootY() + this.getY()),
		// // (int) (this.getRight() - this.getX()),
		// // (int) (this.getBottom() - this.getY()));
		// drawCount++;
		// System.err.println(drawCount);
	}

	public float getWidth() {
		return this.getRight() - this.getX();
	}

	public float getHeight() {
		return this.getBottom() - this.getY();
	}

	public void resetMetrics() {
		this._points = null;
	}

	/**
	 * @param rotation
	 *            the rotation to set
	 */
	public abstract void setRotation(float rotation);

	/**
	 * @return the rotation
	 */
	public abstract float getRotation();

	protected abstract void resetComputedRs();
}
