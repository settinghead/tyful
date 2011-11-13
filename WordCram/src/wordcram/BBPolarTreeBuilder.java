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

import java.awt.geom.Rectangle2D;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;

import wordcram.BBPolarTree.BBPolarChildTree;
import wordcram.BBPolarTree.BBPolarRootTree;

class BBPolarTreeBuilder {

	public BBPolarTreeBuilder() {

	}

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

	public static BBPolarTree makeTree(ImageShape shape, int swelling) {
		Rectangle2D bounds = shape.getBounds2D();
		// int minBoxSize = (int) (shape.getBounds2D().getWidth()
		// * shape.getBounds2D().getHeight() / 1000000);
		// if (minBoxSize == 0)
		// minBoxSize = 1;
		// else if (minBoxSize > 3)
		// minBoxSize = 3;
		int minBoxSize = 1	;
		// center
		int x = (int) (bounds.getX() + bounds.getWidth() / 2);
		int y = (int) (bounds.getY() + bounds.getHeight() / 2);
//		assert (x > 0);
//		assert (y > 0);

		float d = (float) (Math.sqrt(Math.pow(bounds.getWidth() / 2, 2)
				+ Math.pow(bounds.getHeight() / 2, 2)));

		BBPolarRootTree tree = new BBPolarTree.BBPolarRootTree(x, y, d);
		makeChildren(tree, shape, minBoxSize, tree);
		tree.swell(swelling);
		return tree;
	}

	private static void makeChildren(BBPolarTree tree, ImageShape shape,
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
			float r = (tree.getR2() - tree.getR1()) / 4;
			float r1 = tree.getR1();
			float r2 = r1 + r;
			float r3 = r2 + r;
			float r4 = r3 + r;
			float r5 = tree.getR2();
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
			float r = (tree.getR2() - tree.getR1()) / 3;
			float r1 = tree.getR1();
			float r2 = r1 + r;
			float r3 = r2 + r;
			float r4 = tree.getR2();
			float d1 = tree.d1;
			float d2 = tree.d1 + (tree.d2 - tree.d1) / 2;
			float d3 = tree.d2;
			result[0] = makeTree(shape, minBoxSize, r1, r4, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			result[2] = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
			result[3] = makeTree(shape, minBoxSize, r3, r4, d2, d3, root);
		}
			break;
		case _1RAY1CUT: {
			float r = (tree.getR2() - tree.getR1()) / 2;
			float r1 = tree.getR1();
			float r2 = r1 + r;
			float r3 = tree.getR2();
			float d = (tree.d2 - tree.d1) / 2;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = tree.d2;
			result[0] = makeTree(shape, minBoxSize, r1, r2, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r2, r3, d1, d2, root);
			result[2] = makeTree(shape, minBoxSize, r1, r2, d2, d3, root);
			result[3] = makeTree(shape, minBoxSize, r2, r3, d2, d3, root);
		}
			break;
		case _1RAY2CUTS: {
			float r = (tree.getR2() - tree.getR1()) / 2;
			float r1 = tree.getR1();
			float r2 = r1 + r;
			float r3 = tree.getR2();
			float d = (tree.d2 - tree.d1) / 3;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = d2 + d;
			float d4 = tree.d2;
			result[0] = makeTree(shape, minBoxSize, r1, r3, d1, d2, root);
			result[1] = makeTree(shape, minBoxSize, r1, r3, d2, d3, root);
			result[2] = makeTree(shape, minBoxSize, r1, r2, d3, d4, root);
			result[3] = makeTree(shape, minBoxSize, r2, r3, d3, d4, root);
		}
			break;
		case _3CUTS: {
			float r1 = tree.getR1();
			float r2 = tree.getR2();
			float d = (tree.d2 - tree.d1) / 4;
			float d1 = tree.d1;
			float d2 = d1 + d;
			float d3 = d2 + d;
			float d4 = d3 + d;
			float d5 = tree.d2;
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
		// TODO Auto-generated method stub
		// return SplitType.VALUES.get((int) SplitTypePredictor.predict(tree.d1
		// / tree.d2, tree.getR2() - tree.getR1()));
		// float x_in = (tree.d2 - tree.d1)
		// / ((tree.d2 + tree.d1) * (tree.getR2() - tree.getR1()) / 2);
		// int t = (int) SplitTypePredictor.predict(x_in, tree.getR2());
		// if (t < 0 || t >= SplitType.VALUES.size())
		// return SplitType.randomSplitType();
		// return SplitType.VALUES.get(t);
		float factor = (tree.d2 - tree.d1)
				/ ((tree.d2 + tree.d1) * (tree.getR2() - tree.getR1()) / 2);
		if (factor < 0.4)
			return SplitType._3RAYS;
		else if (factor > 0.7)
			return SplitType._3CUTS;
		else
			return SplitType._1RAY1CUT;
	}

	private static BBPolarTree makeTree(ImageShape shape, int minBoxSize,
			float r1, float r2, float d1, float d2, BBPolarRootTree root) {

		BBPolarTree tree = new BBPolarTree.BBPolarChildTree(r1, r2, d1, d2,
				root);
		float x = tree.getX() + tree.getRootX();
		float y = tree.getY() + tree.getRootY();
		float width = tree.getRight() - tree.getX();
		float height = tree.getBottom() - tree.getY();

		if (shape == null || shape.contains(x, y, width, height)) {
			return tree;
		} else {
			if (shape.intersects(x, y, width, height)) {
				float r = r2 - r1;
				float d = 2 * BBPolarTree.PI * d2 * r / BBPolarTree.TWO_PI;

				boolean tooSmallToContinue = d <= minBoxSize
						|| d2 - d1 < minBoxSize;
				if (!tooSmallToContinue) {
					makeChildren(tree, shape, minBoxSize, root);
				}
				return tree;
			} else { // neither contains nor intersects
				return null;
			}
		}
	}

	static int correctCount = 0;

	public static void main(String[] args) {
		Random rnd = new Random();
		correctCount = 0;
		for (int i = 0; i < 4000; i++) {
			float r1 = 0;
			float r2 = 0 + BBPolarTree.TWO_PI * rnd.nextFloat();
			float d2 = rnd.nextFloat() * 100;
			float d1 = rnd.nextFloat() * 100;
			tryOut(r1, r2, d1, d2);
		}
		System.out.println("Correct rate: " + (float) correctCount
				/ (float) 4000);
		// tryOut(BBPolarTree.HALF_PI, BBPolarTree.ONE_AND_HALF_PI, 85, 100);

	}

	private static void tryOut(float r1, float r2, float d1, float d2) {
		// swap
		if (r1 > r2) {
			float tmp = r2;
			r2 = r1;
			r1 = tmp;
		}
		if (d1 > d2) {
			float tmp = d2;
			d2 = d1;
			d1 = tmp;
		}
		BBPolarChildTree tree = new BBPolarChildTree(r1, r2, d1, d2, null);
		SplitType minType = findBestType(tree);
		float x_in = (tree.d2 - tree.d1)
				/ ((tree.d2 + tree.d1) * (tree.getR2() - tree.getR1()) / 2);
		int predictedType = (int) Math.round(SplitTypePredictor.predict(x_in,
				tree.getR2()));
		float y_in = tree.getR2();
		System.out.println(x_in + ", " + y_in + ", "
				+ SplitType.VALUES.indexOf(minType)
		// + ", "
		// + predictedType

				);
		if (predictedType == SplitType.VALUES.indexOf(minType))
			correctCount++;
	}

	private static SplitType findBestType(BBPolarChildTree tree) {
		SplitType minType = SplitType._1RAY1CUT;
		float minAreaDiff = Float.POSITIVE_INFINITY;
		for (SplitType type : SplitType.VALUES) {
			float areaDiff = 0;
			BBPolarTree[] result = splitTree(tree, null, 1, null, type);
			for (int j = 0; j < result.length; j++) {
				float boundingArea = (result[j].getRight() - result[j].getX())
						* (result[j].getBottom() - result[j].getY());
				float actualArea = (float) ((Math.PI
						* Math.pow(result[j].d2, 2) - Math.PI
						* Math.pow(result[j].d1, 2))
						* (result[j].getR2() - result[j].getR1()) / BBPolarTree.TWO_PI);
				assert (boundingArea > 0);
				assert (actualArea > 0);
				assert (boundingArea > actualArea);
				areaDiff += boundingArea - actualArea;
			}

			if (areaDiff < minAreaDiff) {
				minType = type;
				minAreaDiff = areaDiff;
			}
		}
		return minType;
	}

	private static int avg(int a, int b) {
		// reminder: x >> 1 == x / 2
		// avg = (a+b)/2 = (a/2)+(b/2) = (a>>1)+(b>>1)
		return (a + b) >> 1;
	}

	// To the best of my knowledge this code is correct.
	// If you find any errors or problems please contact
	// me at zunzun@zunzun.com.
	// James
	//
	// the code below was partially based on the fortran code at:
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbisp.f
	// http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbspl.f

	static class SplitTypePredictor {
		static double predict(float x_in, float y_in) {
			// double temp;
			// temp = 0.0;
			//
			// // coefficients
			// double a = 4.5869659807374036E-02;
			// double b = 4.8710569403369384E+00;
			// double c = 1.1559512692614707E-01;
			// double d = 1.0222522238957812E-01;
			// double f = 8.4539777422821705E-01;
			// double g = -9.5778653040692407E-01;
			// double h = 2.4405851737311485E-01;
			//
			// temp = (a + b * Math.log(x_in) + c * Math.exp(y_in) + d
			// * Math.log(x_in) * Math.exp(y_in))
			// / (1.0 + f * Math.log(x_in) + g * Math.exp(y_in) + h
			// * Math.log(x_in) * Math.exp(y_in));
			// return temp;
			double temp;
			temp = 0.0;

			// coefficients
			double a = 2.0908149899956006E+00;
			double b = 8.2343554565336274E-03;
			double c = -2.3067489518311901E+00;
			double d = -8.8214951292813267E-07;
			double f = 6.4292874863042182E-01;
			double g = 1.4461702668722154E-11;
			double h = -5.2232020261141744E-02;
			double i = 1.5639260931911458E+00;
			double j = -5.5016274595794711E-03;
			double k = -3.0630768426862615E-01;

			temp += a;
			temp += b * x_in;
			temp += c * y_in;
			temp += d * Math.pow(x_in, 2.0);
			temp += f * Math.pow(y_in, 2.0);
			temp += g * Math.pow(x_in, 3.0);
			temp += h * Math.pow(y_in, 3.0);
			temp += i * x_in * y_in;
			temp += j * Math.pow(x_in, 2.0) * y_in;
			temp += k * x_in * Math.pow(y_in, 2.0);
			return temp;
		}
	}

}