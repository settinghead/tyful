/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.mahout.clustering.spectral.common;

import java.net.URI;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.filecache.DistributedCache;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.SequenceFile;
import org.apache.mahout.common.HadoopUtil;
import org.apache.mahout.common.MahoutTestCase;
import org.apache.mahout.math.DenseVector;
import org.apache.mahout.math.Vector;
import org.apache.mahout.math.VectorWritable;
import org.junit.Test;

public class TestVectorCache extends MahoutTestCase {

  private static final double [] VECTOR = { 1, 2, 3, 4 };
  
  @Test
  public void testSave() throws Exception {
    Configuration conf = new Configuration();
    FileSystem fs = FileSystem.get(conf);
    IntWritable key = new IntWritable(0);
    Vector value = new DenseVector(VECTOR);
    Path path = getTestTempDirPath("output");
    
    // write the vector out
    VectorCache.save(key, value, path, conf, true, true);
    
    // can we read it from here?
    SequenceFile.Reader reader = new SequenceFile.Reader(fs, path, conf);
    VectorWritable old = new VectorWritable();
    reader.next(key, old);
    reader.close();
    
    // test if the values are identical
    assertTrue("Saved vector is identical to original", old.get().equals(value));
  }
  
  @Test
  public void testLoad() throws Exception {
    // save a vector manually
    Configuration conf = new Configuration();
    FileSystem fs = FileSystem.get(conf);
    IntWritable key = new IntWritable(0);
    Vector value = new DenseVector(VECTOR);
    Path path = getTestTempDirPath("output");
    
    // write the vector
    path = fs.makeQualified(path);
    fs.deleteOnExit(path);
    HadoopUtil.overwriteOutput(path);
    DistributedCache.setCacheFiles(new URI[] {path.toUri()}, conf);
    SequenceFile.Writer writer = new SequenceFile.Writer(fs, conf, path, 
        IntWritable.class, VectorWritable.class);
    writer.append(key, new VectorWritable(value));
    writer.close();
    
    // load it
    Vector result = VectorCache.load(key, conf);
    
    // are they the same?
    assertNotNull("Vector is not null", result);
    assertEquals("Loaded vector is identical to original", result, value);
  }
  
  @Test
  public void testAll() throws Exception {
    Configuration conf = new Configuration();
    Vector v = new DenseVector(VECTOR);
    Path toSave = getTestTempDirPath("output");
    IntWritable key = new IntWritable(0);
    
    // save it
    VectorCache.save(key, v, toSave, conf);
    
    // now, load it back
    key = new IntWritable(0);
    Vector v2 = VectorCache.load(key, conf);
    
    // are they the same?
    assertNotNull("Vector is not null", v2);
    assertEquals("Vectors are identical", v2, v);
  }
}
