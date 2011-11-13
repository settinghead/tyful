package wordcram.density;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.awt.image.IndexColorModel;
import java.awt.image.RenderedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.media.jai.*;

import org.apache.commons.collections.list.TreeList;

import wordcram.TemplateImage;
import wordcram.density.DensityPatchIndex.LeveledPatchMap.PatchQueue.Patch;

public class DensityPatchIndex {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4473828963657255566L;
	private TemplateImage img;
	private LeveledPatchMap _map;

	public static final int NUMBER_OF_DIVISIONS = 3;
	private static final double QUEUE_ALPHA_THRESHOLD = 0.01;
	private static double MARK_FILL_FACTOR = 0.6;

	final static byte ff = (byte) 0xff;
	final static byte[] r = { ff, 0, 0, ff, 0 };
	final static byte[] g = { 0, ff, 0, ff, 0 };
	final static byte[] b = { 0, 0, ff, ff, 0 };

	final static ColorModel cm = new IndexColorModel(3, 5, r, g, b);

	public DensityPatchIndex(TemplateImage img) {
		this.img = img;
		_map = new LeveledPatchMap();
	}

	public Patch findPatchFor(int width, int height) {
		int level = findGranularityLevel(width, height);
		if (level < 0)
			level = 0;
		return getBestPatchAtLevel(level, width * height);
	}

	private Patch getBestPatchAtLevel(int level, int smearedArea) {
		Patch result = _map.getBestPatchAtLevel(level, smearedArea);
		if (result == null)
			return getBestPatchAtLevel(level - 1, smearedArea);
		else
			return result;
	}

	private int findGranularityLevel(int width, int height) {
		int max = width > height ? width : height;
		int minContainerLength = img.getWidth() < img.getHeight() ? img
				.getWidth() : img.getHeight();
		int squareWidth = minContainerLength;
		int level = 0;

		while (squareWidth > max) {
			squareWidth /= NUMBER_OF_DIVISIONS;
			level++;
		}

		return level - 1;
	}

	public class LeveledPatchMap {
		/**
		 * 
		 */

		public class PatchQueue {
			/**
			 * 
			 */

			private PriorityQueue<Patch> _queue = new PriorityQueue<Patch>();

			private static final long serialVersionUID = 7572399768909383070L;
			private final int myLevel;

			PatchQueue(int myLevel) {
				this.myLevel = myLevel;
				if (myLevel == 0) {
					tryAdd(this.new Patch(0, 0, img.getWidth(),
							img.getHeight(), 0, null));
				}
			}

			public Patch getBestPatch(int smearedArea) {
				Patch result = poll();
				if (result != null) {
					result.mark(smearedArea);
					tryAdd(result);
				}
				return result;
			}

			private Patch poll() {
				return _queue.poll();
			}

			/**
			 * @return the myLevel
			 */
			int getMyLevel() {
				return myLevel;
			}

			public class Patch implements Comparable<Patch> {

				private static final long serialVersionUID = 3840961038214839458L;

				private int x;
				private int y;
				private int width;
				private int height;
				private double _averageAlpha = -1;
				private Patch parent;
				private Vector<Patch> children = null;
				private Set<Patch> _childrenMarker;
				private int _area = -1;
				private double _alphaSum = -1;

				private final int rank;

				float[] rgbPixelToHsv(int pixel) {
					int r = cm.getRed(pixel), g = cm.getGreen(pixel), b = cm
							.getBlue(pixel);
					return Color.RGBtoHSB(r, g, b, null);
				}

				public Patch(int x, int y, int width, int height, int rank,
						Patch parent) {

					this.setX(x);
					this.setY(y);
					this.setWidth(width);
					this.setHeight(height);
					this.setParent(parent);
					this.rank = rank;

				}

				public void setX(int x) {
					this.x = x;
				}

				public int getX() {
					return x;
				}

				public void setY(int y) {
					this.y = y;
				}

				public int getY() {
					return y;
				}

				public TemplateImage getImg() {
					return DensityPatchIndex.this.img;
				}

				private void setWidth(int width) {
					this.width = width;
				}

				public int getWidth() {
					return width;
				}

				public double getAverageAlpha() {

					if (this._averageAlpha < 0) {

						// now remove sub-patches that's already marked
						this._averageAlpha = this.getAlphaSum();
						for (Patch markedChild : getMarkedChildren()) {
							this._averageAlpha -= markedChild.getAverageAlpha()
									* MARK_FILL_FACTOR;
						}

						this._averageAlpha /= (double) this.getArea();

					}
					return this._averageAlpha;
				}

				private double getAlphaSum() {
					if (this._alphaSum < 0)
					// lazy calc
					{
						this._alphaSum = 0;

						if (this.getChildren() == null
								|| this.getChildren().size() == 0) {
							for (int i = 0; i < this.getWidth(); i++)
								for (int j = 0; j < this.getHeight(); j++) {
									this._alphaSum += img.getBrightness(
											this.getX() + i, this.getY() + j);
								}
						} else
							for (Patch p : this.getChildren())
								this._alphaSum += p.getAlphaSum();
					}

					return this._alphaSum;
				}

				private Set<Patch> getMarkedChildren() {
					if (this._childrenMarker == null)
						this._childrenMarker = new HashSet<Patch>();
					return this._childrenMarker;
				}

				public int compareTo(Patch p) {
					int r = -Double.compare(this.getAverageAlpha(),
							p.getAverageAlpha());
					if (r == 0)
						return this.getRank() - p.getRank();
					else
						return r;
				}

				private int getRank() {
					return this.rank;
				}

				private void setHeight(int height) {
					this.height = height;
				}

				public int getHeight() {
					return height;
				}

				private void setParent(Patch parent) {
					this.parent = parent;
				}

				public Patch getParent() {
					return parent;
				}

				private void setChildren(Vector<Patch> children) {
					this.children = children;
				}

				public Vector<Patch> getChildren() {
					return children;
				}

				Collection<Patch> divideIntoNineOrMore() {
					Vector<Patch> result = new Vector<Patch>();
					int min = getWidth() < getHeight() ? getWidth()
							: getHeight();
					int squareLength = min / NUMBER_OF_DIVISIONS;
					int centerCount = (NUMBER_OF_DIVISIONS + 1) / 2;
					boolean breakI = false;
					for (int i = 0; i < getWidth(); i += squareLength) {
						int squareWidth;
						if (i + squareLength * 2 > getWidth()) {
							squareWidth = getWidth() - i;
							// i = getWidth();
							breakI = true;
						} else
							squareWidth = squareLength;
						boolean breakJ = false;

						for (int j = 0; j < getHeight(); j += squareLength) {
							int squareHeight;
							if (j + squareLength * 2 > getHeight()) {
								squareHeight = getHeight() - j;
								// j = getHeight();
								breakJ = true;
							} else
								squareHeight = squareLength;

							// the closer to the center, the higher the rank
							Patch p = new Patch(getX() + i, getY() + j,
									squareWidth, squareHeight, 0, this);
							result.add(p);
							if (breakJ)
								break;
						}
						if (breakI)
							break;
					}

					setChildren(result);
					return result;
				}

				@Override
				public String toString() {
					return ("x: " + getX() + ", y: " + getY() + ", width: "
							+ getWidth() + ", height: " + getHeight());
				}

				public void mark(int smearedArea) {
					this.resetWorthCalculations();
					this.getAlphaSum();
					if (this.getChildren() == null
							|| this.getChildren().size() == 0)
						this._alphaSum -= smearedArea * MARK_FILL_FACTOR;

					if (getParent() != null)
						getParent().markChild(this);

				}

				public void unmarkForParent() {
					if (getParent() != null)
						getParent().unmarkChild(this);
				}

				private void markChild(Patch patch) {
					this.getMarkedChildren().add(patch);
					this.resetWorthCalculations();
					// re-sort
					this.reRank();
					// // cascading mark parents
					// if (this.getParent() != null)
					// this.getParent().markChild(this);
				}

				private void unmarkChild(Patch patch) {
					if (this.getMarkedChildren().remove(patch)) {
						this.resetWorthCalculations();
						// re-sort
						this.reRank();
						// cascading mark parents
						// if (this.getParent() != null)
						// this.getParent().markChild(this);
						// this.unmarkForParent();
					}
				}

				private void resetWorthCalculations() {
					this._area = -1;
					this._averageAlpha = -1;

				}

				/**
				 * @return the area
				 */
				public int getArea() {
					if (this._area < 0)
						this._area = getWidth() * getHeight();
					return this._area;
				}

				public void reRank() {
					PatchQueue.this.remove(this);
					PatchQueue.this.tryAdd(this);
					if (getParent() != null) {
						getParent().resetWorthCalculations();
						getParent().reRank();
					}
				}

				public int getLevel() {
					return PatchQueue.this.getMyLevel();
				}
			}

			private PatchQueue descend(int queueLevel) {
				PatchQueue queue = new PatchQueue(queueLevel);
				for (Patch patch : this._queue) {
					queue.tryAddAll(patch.divideIntoNineOrMore());
				}
				return queue;
			}

			public void remove(Patch patch) {
				_queue.remove(patch);
			}

			private void tryAddAll(Collection<Patch> patches) {
				for (Patch p : patches)
					tryAdd(p);

			}

			private void tryAdd(Patch p) {
				if (p.getAverageAlpha() > QUEUE_ALPHA_THRESHOLD)
					_queue.offer(p);
			}
		}

		private static final long serialVersionUID = -7890656842460461670L;
		private Vector<PatchQueue> _map = new Vector<PatchQueue>();

		public LeveledPatchMap() {
			// top level
			PatchQueue topLevelQueue = new PatchQueue(0);
			_map.add(topLevelQueue);
		}

		public Patch getBestPatchAtLevel(int level, int smearedArea) {
			PatchQueue queue = getQueue(level);
			return queue.getBestPatch(smearedArea);
		}

		private PatchQueue getQueue(int level) {
			if (level >= _map.size())
				generateLevelQueue(level);
			return _map.get(level);

		}

		private void generateLevelQueue(int level) {
			if (level > _map.size())
				generateLevelQueue(level - 1);
			_map.add((_map.get(_map.size() - 1).descend(level)));

		}

	}

	public static void main(String[] args) throws IOException {
		// RenderedImage image = JAI.create("fileload", "dog_sillhouette.jpg");

		TemplateImage img = new TemplateImage(ImageIO.read(new File("dog.png")));

		DensityPatchIndex index = new DensityPatchIndex(img);
		System.out.println(index.findPatchFor(20, 20));
	}

	public void unmark(Patch patch) {
		patch.unmarkForParent();
	}
}
