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

package org.apache.mahout.fpm.pfpgrowth.convertors.string;

import java.util.Iterator;
import java.util.List;

import org.apache.mahout.common.StringTuple;

/**
 * Iterate over the StringTuple as an iterator of <code>List&lt;String&gt;</code>
 *
 */
public final class StringTupleIterator implements Iterator<List<String>> {
  
  private final Iterator<StringTuple> iterator;
  
  public StringTupleIterator(Iterator<StringTuple> iterator) {
    this.iterator = iterator;
  }
  
  @Override
  public boolean hasNext() {
    return iterator.hasNext();
  }
  
  @Override
  public List<String> next() {
    StringTuple transaction = iterator.next();
    return transaction.getEntries();
  }
  
  @Override
  public void remove() {
    iterator.remove();
  }
  
}
