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

	protected long rStamp;

	protected float _x = Integer.MIN_VALUE, _y = Integer.MIN_VALUE,
			_right = Integer.MIN_VALUE, _bottom = Integer.MIN_VALUE;

	public static class BBPolarRootTree extends BBPolarTree {
		private int rootX;
		private int rootY;
		private float _rotation = 0;
		protected long rootStamp;
		private final ImageShape shape;
		final int _minBoxSize;

		public BBPolarRootTree(ImageShape shape, int centerX, int centerY,
				float d, int minBoxSize) {
			super(0, TWO_PI, 0, d, minBoxSize);
			this.rootX = centerX;
			this.rootY = centerY;
			this.shape = shape;
			this._minBoxSize = minBoxSize;
			this.rootStamp = System.currentTimeMillis();
		}

		void setLocation(int centerX, int centerY) {
			this.rootX = centerX;
			this.rootY = centerY;
			this.rootStamp = System.currentTimeMillis();
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
		protected float computeX(boolean rotate) {
			return (float) -super.d2;
		}

		@Override
		protected float computeY(boolean rotate) {
			return (float) -super.d2;
		}

		@Override
		protected float computeRight(boolean rotate) {
			return (float) super.d2;
		}

		@Override
		protected float computeBottom(boolean rotate) {
			return (float) super.d2;
		}

		public void setRotation(float rotation) {
			this._rotation = rotation;
			this.rootStamp = System.currentTimeMillis();
		}

		@Override
		public float getRotation() {
			return this._rotation;
		}

		@Override
		long getCurrentStamp() {
			return this.rootStamp;
		}

		@Override
		BBPolarRootTree getRoot() {
			return this;
		}

		@Override
		int getMinBoxSize() {
			return this._minBoxSize;
		}

		@Override
		ImageShape getShape() {
			return this.shape;
		}

	}

	public static class BBPolarChildTree extends BBPolarTree {

		BBPolarRootTree root;

		BBPolarChildTree(float r1, float r2, float d1, float d2,
				BBPolarRootTree root, int minBoxSize) {
			super(r1, r2, d1, d2, minBoxSize);
			this.root = root;
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
		float computeX(boolean rotate) {
			float x;
			if (getR1(rotate) < HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					x = (float) (d2 * Math.cos(PI));
				} else if (getR2(rotate) < HALF_PI) {
					x = (float) (d1 * Math.cos(getR2(rotate)));
				} else if (getR2(rotate) < PI) {
					x = (float) (d2 * Math.cos(getR2(rotate)));
				} else {
					// circle
					x = (float) (d2 * Math.cos(PI));
				}
			} else if (getR1(rotate) < PI) {
				if (getR2(rotate) < HALF_PI) {
					x = (float) (d2 * Math.cos(PI));
				} else if (getR2(rotate) < PI) {
					x = (float) (d2 * Math.cos(getR2(rotate)));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					x = (float) (d2 * Math.cos(PI));
				} else {
					x = (float) (d2 * Math.cos(PI));
				}
			} else if (getR1(rotate) < ONE_AND_HALF_PI) {
				if (getR2(rotate) < HALF_PI) {
					x = (float) (d2 * Math.cos(getR1(rotate)));
				} else if (getR2(rotate) < getR1(rotate)) {
					float x1 = (float) (d2 * Math.cos(getR1(rotate)));
					float x2 = (float) (d2 * Math.cos(getR2(rotate)));
					x = x1 < x2 ? x1 : x2;
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					x = (float) (d2 * Math.cos(getR1(rotate)));
				} else {
					x = (float) (d2 * Math.cos(getR1(rotate)));
				}
			} else {
				if (getR2(rotate) < HALF_PI) {
					float x1 = (float) (d1 * Math.cos(getR1(rotate)));
					float x2 = (float) (d1 * Math.cos(getR2(rotate)));
					x = x1 < x2 ? x1 : x2;
				} else if (getR2(rotate) < PI) {
					x = (float) (d2 * Math.cos(getR2(rotate)));
				} else if (getR2(rotate) < getR1(rotate)) {
					x = (float) (d2 * Math.cos(PI));
				} else
					x = (float) (d1 * Math.cos(getR1(rotate)));
			}
			return x;
		}

		@Override
		float computeY(boolean rotate) {
			float y;
			if (getR1(rotate) < HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					y = (float) (d1 * Math.sin(HALF_PI));
				} else if (getR2(rotate) < HALF_PI) {
					y = (float) (d2 * Math.sin(getR2(rotate)));
				} else if (getR2(rotate) < PI) {
					y = (float) (d2 * Math.sin(HALF_PI));
				} else {
					// circle
					y = (float) (d2 * Math.sin(HALF_PI));
				}
			} else if (getR1(rotate) < PI) {
				if (getR2(rotate) < HALF_PI) {
					float y1 = (float) (d2 * Math.sin(getR1(rotate)));
					float y2 = (float) (d2 * Math.sin(getR2(rotate)));
					y = y1 > y2 ? y1 : y2;
				} else if (getR1(rotate) < getR2(rotate))
					y = (float) (d2 * Math.sin(HALF_PI));
				else
					y = (float) (d2 * Math.sin(getR1(rotate)));
			} else if (getR1(rotate) < ONE_AND_HALF_PI) {
				if (getR2(rotate) < PI) {
					y = (float) (d2 * Math.sin(HALF_PI));
				} else if (getR2(rotate) < getR1(rotate)) {
					y = (float) (d1 * Math.sin(getR2(rotate)));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					y = (float) (d1 * Math.sin(getR1(rotate)));
				} else {
					float val1 = (float) (d1 * Math.sin(getR2(rotate)));
					float val2 = (float) (d1 * Math.sin(getR1(rotate)));
					y = val1 > val2 ? val1 : val2;
				}

			} else {
				if (getR2(rotate) < HALF_PI) {
					y = (float) (d2 * Math.sin(getR2(rotate)));
				} else if (getR2(rotate) < getR1(rotate)) {
					y = (float) (d2 * Math.sin(HALF_PI));
				} else
					y = (float) (d1 * Math.sin(getR2(rotate)));
			}
			y = -y;
			return y;
		}

		@Override
		float computeRight(boolean rotate) {
			float right;
			if (getR1(rotate) < HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					right = (float) (d2 * Math.cos(0));
				} else if (getR2(rotate) < HALF_PI) {
					right = (float) (d2 * Math.cos(getR1(rotate)));
				} else if (getR2(rotate) < PI) {
					right = (float) (d2 * Math.cos(getR1(rotate)));
				} else {
					// circle
					right = (float) (d2 * Math.cos(0));
				}
			} else if (getR1(rotate) < PI) {
				if (getR2(rotate) < getR1(rotate)) {
					right = (float) (d2 * Math.cos(0));
				} else if (getR2(rotate) < PI) {
					right = (float) (d1 * Math.cos(getR1(rotate)));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					float val1 = (float) (d1 * Math.cos(getR1(rotate)));
					;
					float val2 = (float) (d1 * Math.cos(getR2(rotate)));
					;
					right = val1 > val2 ? val1 : val2;
				} else {
					right = (float) (d2 * Math.cos(getR2(rotate)));
				}
			} else if (getR1(rotate) < ONE_AND_HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					right = (float) (d2 * Math.cos(0));
				}
				if (getR2(rotate) < ONE_AND_HALF_PI) {
					right = (float) (d1 * Math.cos(getR2(rotate)));
				} else {
					right = (float) (d2 * Math.cos(getR2(rotate)));
				}

			} else {
				if (getR2(rotate) < getR1(rotate)) {
					right = (float) (d2 * Math.cos(0));
				} else
					right = (float) (d2 * Math.cos(getR2(rotate)));
			}

			return right;

		}

		@Override
		float computeBottom(boolean rotate) {
			float bottom;
			if (getR1(rotate) < HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					bottom = (float) (d1 * Math.sin(ONE_AND_HALF_PI));
				} else if (getR2(rotate) < HALF_PI) {
					bottom = (float) (d1 * Math.sin(getR1(rotate)));
				} else if (getR2(rotate) < PI) {
					float val1 = (float) (d1 * Math.sin(getR1(rotate)));
					float val2 = (float) (d1 * Math.sin(getR2(rotate)));
					bottom = val1 < val2 ? val1 : val2;
				} else {
					// circle
					bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
				}
			} else if (getR1(rotate) < PI) {
				if (getR2(rotate) < getR1(rotate)) {
					bottom = (float) (d1 * Math.sin(ONE_AND_HALF_PI));
				}
				if (getR2(rotate) < PI) {
					bottom = (float) (d1 * Math.sin(getR2(rotate)));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					bottom = (float) (d2 * Math.sin(getR2(rotate)));
				} else {
					bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
				}
			} else if (getR1(rotate) < ONE_AND_HALF_PI) {
				if (getR2(rotate) < getR1(rotate)) {
					bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					bottom = (float) (d2 * Math.sin(getR2(rotate)));
				} else {
					bottom = (float) (d2 * Math.sin(ONE_AND_HALF_PI));
				}

			} else {
				if (getR2(rotate) < PI) {
					bottom = (float) (d2 * Math.sin(getR1(rotate)));
				} else if (getR2(rotate) < ONE_AND_HALF_PI) {
					float b1 = (float) (d2 * Math.sin(getR1(rotate)));
					float b2 = (float) (d2 * Math.sin(getR2(rotate)));
					bottom = b1 < b2 ? b1 : b2;
				} else if (getR2(rotate) < getR1(rotate)) {
					bottom = (float) Math.cos(ONE_AND_HALF_PI);
				} else
					bottom = (float) (d2 * Math.sin(getR1(rotate)));
			}
			bottom = -bottom;
			return bottom;
		}

		@Override
		public float getRotation() {
			return root.getRotation();
		}

		@Override
		long getCurrentStamp() {
			return root.getCurrentStamp();
		}

		@Override
		BBPolarRootTree getRoot() {
			return root;
		}

		@Override
		int getMinBoxSize() {
			return root.getMinBoxSize();
		}

		@Override
		ImageShape getShape() {
			return root.getShape();
		}
	}

	protected float _r1, d1, _r2, d2, r;
	protected BBPolarTree[] _kids;
	private float[] _points;
	protected float _computedR1 = Float.NaN, _computedR2 = Float.NaN;
	private long pointsStamp;

	BBPolarTree(float r1, float r2, float d1, float d2, int minBoxSize) {
		this._r1 = r1;
		this._r2 = r2;
		this.d1 = d1;
		this.d2 = d2;
		float r = r2 - r1;
		float d = 2 * BBPolarTree.PI * d2 * r / BBPolarTree.TWO_PI;

		boolean tooSmallToContinue = d <= minBoxSize || d2 - d1 < minBoxSize;
		if (tooSmallToContinue)
			this.setLeaf(true);
	}

	void addKids(BBPolarTree... kids) {
		ArrayList<BBPolarTree> kidList = new ArrayList<BBPolarTree>();
		for (BBPolarTree kid : kids) {
			if (kid != null) {
				kidList.add(kid);
			}
		}
		_kids = kidList.toArray(new BBPolarTree[0]);
	}

	abstract int getRootX();

	abstract int getRootY();

	boolean overlaps(BBPolarTree otherTree) {

		if (this.rectCollide(otherTree)) {
			if (this.isLeaf() && otherTree.isLeaf()) {
				return true;
			} else if (this.isLeaf()) { // Then otherTree isn't a leaf.
				for (BBPolarTree otherKid : otherTree.getKids()) {
					if (this.overlaps(otherKid)) {
						return true;
					}
				}
			} else {
				for (BBPolarTree myKid : this.getKids()) {
					if (otherTree.overlaps(myKid)) {
						return true;
					}
				}
			}
		}
		return false;
	}

	private BBPolarTree[] getKids() {
		if ((!this.isLeaf()) && this._kids == null)
			BBPolarTreeBuilder.makeChildren(this, getShape(), getMinBoxSize(),
					getRoot());
		return this._kids;
	}

	abstract BBPolarRootTree getRoot();

	abstract int getMinBoxSize();

	abstract ImageShape getShape();

	boolean overlaps(float x, float y, float right, float bottom) {

		if (this.rectCollide(x, y, right, bottom)) {
			if (this.isLeaf()) {
				return true;
			} else {
				for (BBPolarTree myKid : this.getKids()) {
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
				for (BBPolarTree myKid : this.getKids()) {
					if (myKid.contains(x, y, right, bottom)) {
						return true;
					}
				}
				return false;
			}
		} else
			return false;
	}

	abstract float computeX(boolean rotate);

	abstract float computeY(boolean rotate);

	abstract float computeRight(boolean rotate);

	abstract float computeBottom(boolean rotate);

	public float getR1(boolean rotate) {
		if (rotate) {
			checkRecompute();
			return this._computedR1;
		} else
			return this._r1;
	}

	public float getR2(boolean rotate) {
		if (rotate) {
			checkRecompute();
			return this._computedR2;
		} else
			return this._r2;
	}

	void checkRecompute() {
		if (this.rStamp != this.getCurrentStamp()) {
			computeR1();
			computeR2();
			this.rStamp = this.getCurrentStamp();
		}
	}

	private void computeR1() {
		_computedR1 = this._r1 + getRotation();
		if (_computedR1 > TWO_PI)
			this._computedR1 = (_computedR1) % TWO_PI;

	}

	private void computeR2() {
		this._computedR2 = this._r2 + getRotation();
		if (this._computedR2 > TWO_PI)
			this._computedR2 = (_computedR2) % TWO_PI;

	}

	private float[] getPoints() {
		if (this.pointsStamp != this.getCurrentStamp()) {
			this._points = new float[] { getRootX() - swelling + getX(true),
					getRootY() - swelling + getY(true),
					getRootX() + swelling + getRight(true),
					getRootY() + swelling + getBottom(true) };
			this.pointsStamp = this.getCurrentStamp();
		}
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
		return _leaf;
	}

	int swelling = 0;
	private long xStamp, yStamp, rightStamp, bottomStamp;
	private boolean _leaf = false;
	private float _relativeX = Float.NaN, _relativeY = Float.NaN,
			_relativeRight = Float.NaN, _relativeBottom = Float.NaN;

	void swell(int extra) {
		swelling += extra;
		if (!isLeaf()) {
			for (int i = 0; i < getKids().length; i++) {
				getKids()[i].swell(extra);
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
			drawBounds(g);
		} else {
			for (int i = 0; i < getKids().length; i++) {
				getKids()[i].drawLeaves(g);
			}
		}
	}

	private void drawLeaves(PGraphics g) {
		if (this.isLeaf()) {
			drawBounds(g, getPoints());
		} else {
			for (int i = 0; i < getKids().length; i++) {
				getKids()[i].drawLeaves(g);
			}
		}
	}

	private void drawBounds(PGraphics g, float[] rect) {
		g.rect(rect[0], rect[1], rect[2], rect[3]);
	}

	static int drawCount = 0;

	private void drawBounds(Graphics g) {
		int x1, x2, x3, x4, y1, y2, y3, y4;
		x1 = (int) (this.getRootX() + this.d1 * Math.cos(getR1(true)));
		y1 = (int) (this.getRootY() - this.d1 * Math.sin(getR1(true)));
		x2 = (int) (this.getRootX() + this.d1 * Math.cos(getR2(true)));
		y2 = (int) (this.getRootY() - this.d1 * Math.sin(getR2(true)));
		x3 = (int) (this.getRootX() + this.d2 * Math.cos(getR1(true)));
		y3 = (int) (this.getRootY() - this.d2 * Math.sin(getR1(true)));
		x4 = (int) (this.getRootX() + this.d2 * Math.cos(getR2(true)));
		y4 = (int) (this.getRootY() - this.d2 * Math.sin(getR2(true)));

		float r = this.getR2(true) - this.getR1(true);
		if (r < 0)
			r = TWO_PI + r;
		assert (r < PI);

		g.drawArc((int) (this.getRootX() - this.d2),
				(int) (this.getRootY() - this.d2), (int) (this.d2 * 2),
				(int) (this.d2 * 2), (int) Math.toDegrees(this.getR1(true)),
				(int) Math.toDegrees(r) + 1);
		g.drawArc((int) (this.getRootX() - this.d1),
				(int) (this.getRootY() - this.d1), (int) (this.d1 * 2),
				(int) (this.d1 * 2), (int) Math.toDegrees(this.getR1(true)),
				(int) Math.toDegrees(r));
		g.drawLine(x1, y1, x3, y3);
		g.drawLine(x2, y2, x4, y4);

	}

	public float getWidth(boolean rotate) {
		return this.getRight(rotate) - this.getX(rotate);
	}

	public float getHeight(boolean rotate) {
		return this.getBottom(rotate) - this.getY(rotate);
	}

	/**
	 * @param rotation
	 *            the rotation to set
	 */

	private void checkComputeX() {
		if (this.xStamp != this.getCurrentStamp()) {
			this._x = computeX(true);
			this.xStamp = this.getCurrentStamp();
		}
	}

	private void checkComputeY() {
		if (this.yStamp != this.getCurrentStamp()) {
			this._y = computeY(true);
			this.yStamp = this.getCurrentStamp();
		}

	}

	private void checkComputeRight() {
		if (this.rightStamp != this.getCurrentStamp()) {
			this._right = computeRight(true);
			this.rightStamp = this.getCurrentStamp();
		}
	}

	private void checkComputeBottom() {
		if (this.bottomStamp != this.getCurrentStamp()) {
			this._bottom = computeBottom(true);
			this.bottomStamp = this.getCurrentStamp();
		}
	}

	private float getRelativeX() {
		if (Float.isNaN(this._relativeX))
			this._relativeX = computeX(false);
		return this._relativeX;
	}

	private float getRelativeY() {
		if (Float.isNaN(this._relativeY))
			this._relativeY = computeY(false);
		return this._relativeY;
	}

	private float getRelativeRight() {
		if (Float.isNaN(this._relativeRight))
			this._relativeRight = computeRight(false);
		return this._relativeRight;
	}

	private float getRelativeBottom() {
		if (Float.isNaN(this._relativeBottom))
			this._relativeBottom = computeBottom(false);
		return this._relativeBottom;
	}

	protected float getX(boolean rotate) {
		if (rotate) {
			checkComputeX();
			return _x;
		} else
			return getRelativeX();
	}

	protected float getY(boolean rotate) {
		if (rotate) {
			checkComputeY();
			return _y;
		} else
			return getRelativeY();
	}

	protected float getRight(boolean rotate) {
		if (rotate) {
			checkComputeRight();
			return _right;
		} else
			return getRelativeRight();
	}

	protected float getBottom(boolean rotate) {
		if (rotate) {
			checkComputeBottom();
			return _bottom;
		}
		return getRelativeBottom();
	}

	/**
	 * @return the rotation
	 */
	public abstract float getRotation();

	abstract long getCurrentStamp();

	public void setLeaf(boolean b) {
		this._leaf = b;
	}

}
