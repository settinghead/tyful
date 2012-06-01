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

package org.apache.mahout.common;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

public class StringRecordIterator implements Iterator<Pair<List<String>,Long>> {
  
  private static final Long ONE = 1L;
  
  private final Iterator<String> lineIterator;
  private final Pattern splitter;
  
  public StringRecordIterator(FileLineIterable iterable, String pattern) {
    this.lineIterator = iterable.iterator();
    this.splitter = Pattern.compile(pattern);
  }
  
  @Override
  public boolean hasNext() {
    return lineIterator.hasNext();
  }
  
  @Override
  public Pair<List<String>,Long> next() {
    String line = lineIterator.next();
    String[] items = splitter.split(line);
    return new Pair<List<String>,Long>(Arrays.asList(items), ONE);
  }
  
  @Override
  public void remove() {
    lineIterator.remove();
  }
  
}