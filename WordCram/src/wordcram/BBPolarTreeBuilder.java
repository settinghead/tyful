package wordcram;

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

import java.awt.Rectangle;
import java.awt.geom.Rectangle2D;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import wordcram.BBPolarTree.BBPolarChildTree;
import wordcram.BBPolarTree.BBPolarRootTree;

final class BBPolarTreeBuilder {

	enum SplitType {
		_3RAYS, _2RAYS1CUT, _1RAY1CUT, _1RAY2CUTS, _3CUTS;
		private static final List<SplitType> VALUES = Collections
				.unmodifiableList(Arrays.asList(values()));
		private static final int SIZE = VALUES.size();
		private static final Random RANDOM = new Random();

		public static SplitType randomSplitType() {
			return VALUES.get(RANDOM.nextInt(SIZE));
		}
	}

	public static BBPolarRootTree makeTree(ImageShape shape, int swelling) {
		Rectangle2D bounds = shape.getBounds2D();
		int minBoxSize = 1;
		// center
		int x = (int) (bounds.getX() + bounds.getWidth() / 2);
		int y = (int) (bounds.getY() + bounds.getHeight() / 2);
		// assert (x > 0);
		// assert (y > 0);

		float d = (float) (Math.sqrt(Math.pow(bounds.getWidth() / 2, 2)
				+ Math.pow(bounds.getHeight() / 2, 2)));

		BBPolarRootTree tree = new BBPolarTree.BBPolarRootTree(shape, x, y, d,
				minBoxSize);
		// makeChildren(tree, shape, minBoxSize, tree);
		// tree.swell(swelling);
		return tree;
	}

	protected static void makeChildren(BBPolarTree tree, ImageShape shape,
			int minBoxSize, BBPolarRootTree root) {
		SplitType type = determineType(tree);

		BBPolarTree[] children = splitTree(tree, shape, minBoxSize, root, type);

		tree.addKids(children);
	}

	static BBPolarTree[] splitTree(BBPolarTree tree, ImageShape shape,
			int minBoxSize, BBPolarRootTree root, SplitType type) {
		BBPolarTree[] result = new BBPolarTree[4];
		switch (type) {
		case _3RAYS: {
			float r = (tree.getR2(false) - tree.getR1(false)) / 4;
			float r1 = tree.getR1(false);
			float r2 = r1 + r;
			float r3 = r2 + r;
			float r4 = r3 + r;
			float r5 = tree.getR2(false);
			assert (r1 < r2 && r2 < r3 && r3 < r4 && r4 < r5);
			result[0] = makeTree(shape, minBoxSize, r1, r2, tree.d1, tree.d2,
					root);
			result[1] = makeTree(shape, minBoxSize, r2, r3, tree.d1, tree.d2,
					root);
			result[2] = makeTree(shape, minBoxSize, r3, r4, tree.d1, tree.d2,
					root);
			result[3] = makeTree(shape, minBoxSize, r4, r5, tree.d1, tree.d2,
					root);
		}
			break;

		case _2RAYS1CUT: {
			float r = (tree.getR2(false) - tree.getR1(false)) / 3;
			float r1 = tree.getR1(false);
			float r2 = r1 + r;
			float r3 = r2 + r;
			float r4 = tree.getR2(false);
			float d1 = tree.d1;
			float d2 = tree.d1 + (tree.d2 - tree.d1) / 2;
			float d3 = tree.d2;
			assert (r1 < r2 && r2 < r3 && r3 < r4);

			result[0] = makeTree(shape, minBoxSize, r1, r4, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			result[2] = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
			result[3] = makeTree(shape, minBoxSize, r3, r4, d2, d3, root);
		}
			break;
		case _1RAY1CUT: {
			float r = (tree.getR2(false) - tree.getR1(false)) / 2;
			float r1 = tree.getR1(false);
			float r2 = r1 + r;
			float r3 = tree.getR2(false);
			float d = (tree.d2 - tree.d1) / 2;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = tree.d2;
			assert (r1 < r2 && r2 < r3);

			result[0] = makeTree(shape, minBoxSize, r1, r2, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r2, r3, d1, d2, root);
			result[2] = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			result[3] = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
		}
			break;
		case _1RAY2CUTS: {
			float r = (tree.getR2(false) - tree.getR1(false)) / 2;
			float r1 = tree.getR1(false);
			float r2 = r1 + r;
			float r3 = tree.getR2(false);
			float d = (tree.d2 - tree.d1) / 3;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = d2 + d;
			float d4 = tree.d2;
			assert (r1 < r2 && r2 < r3);

			result[0] = makeTree(shape, minBoxSize, r1, r3, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r1, r3, d2, d3, root);
			result[2] = makeTree(shape, minBoxSize, r1, r2, d3, d4, root);
			result[3] = makeTree(shape, minBoxSize, r2, r3, d3, d4, root);
		}
			break;
		case _3CUTS: {
			float r1 = tree.getR1(false);
			float r2 = tree.getR2(false);
			float d = (tree.d2 - tree.d1) / 4;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = d2 + d;
			float d4 = d3 + d;
			float d5 = tree.d2;
			assert (r1 < r2);

			result[0] = makeTree(shape, minBoxSize, r1, r2, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			result[2] = makeTree(shape, minBoxSize, r1, r2, d3, d4, root);
			result[3] = makeTree(shape, minBoxSize, r1, r2, d4, d5, root);
		}
			break;
		}
		return result;
	}

	private static SplitType determineType(BBPolarTree tree) {
		float d = (tree.d2 - tree.d1);
		float midLength = ((tree.d2 + tree.d1)
				* (tree.getR2(false) - tree.getR1(false)) / 2);
		float factor = d / midLength;
		// System.out.println("d=" + d + ", midLength=" + midLength + ",factor="
		// + factor);
		if (factor < 0.8)
			return SplitType._3RAYS;
		else if (factor > 1.2)
			return SplitType._3CUTS;
		else
			return SplitType._1RAY1CUT;
	}

	private static BBPolarTree makeTree(ImageShape shape, int minBoxSize,
			float r1, float r2, float d1, float d2, BBPolarRootTree root) {

		BBPolarTree tree = new BBPolarTree.BBPolarChildTree(r1, r2, d1, d2,
				root, minBoxSize);
		Rectangle2D r = shape.getBounds2D();
		float x = (float) (tree.getX(false) + r.getWidth() / 2);
		float y = (float) (tree.getY(false) + r.getHeight() / 2);
		float width = tree.getRight(false) - tree.getX(false);
		float height = tree.getBottom(false) - tree.getY(false);
		assert (width > 0);
		assert (height > 0);

		if (shape == null || shape.contains(x, y, width, height)) {
			return tree;
		} else {
			if (shape.intersects(x, y, width, height)) {
				return tree;
			} else { // neither contains nor intersects
				return null;
			}
		}
	}

	static int correctCount = 0;

	// To the best of my knowledge this code is correct.
	// If you find any errors or problems please contact
	// me at zunzun@zunzun.com.
	// James
	//
	// the code below was partially based on the fortran code at:
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbisp.f
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbspl.f

}