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

package org.apache.mahout.common.cache;

import java.util.ConcurrentModificationException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.commons.lang.mutable.MutableLong;
import org.apache.mahout.common.Pair;

public class LFUCache<K,V> implements Cache<K,V> {
  
  private final SortedMap<Long,Set<K>> evictionMap;
  
  private final Map<K,Pair<V, MutableLong>> dataMap;
  
  private final int capacity;
  
  private int evictionCount;
  
  public LFUCache(int capacity) {   
    this.capacity = capacity;
    
    evictionMap = new TreeMap<Long,Set<K>>();
    dataMap = new HashMap<K,Pair<V,MutableLong>>(capacity);
  }
  
  @Override
  public long capacity() {
    return capacity;
  }
  
  public int getEvictionCount() {
    return this.evictionCount;
  }
  
  @Override
  public V get(K key) {
    Pair<V,MutableLong> data = dataMap.get(key);
    if (data == null) {
      return null;
    } else {
      V value = data.getFirst();
      MutableLong count = data.getSecond();
      long oldCount = count.longValue();
      count.increment();
      incrementHit(key, oldCount);
      return value;
    }
    
  }
  
  public V quickGet(K key) {
    Pair<V,MutableLong> data = dataMap.get(key);
    return data == null ? null : data.getFirst();
  }
  
  private void incrementHit(K key, long count) {
    Set<K> keys = evictionMap.get(count);
    if (keys == null) {
      throw new ConcurrentModificationException();
    }
    if (!keys.remove(key)) {
      throw new ConcurrentModificationException();
    }
    if (keys.isEmpty()) {
      evictionMap.remove(count);
    }
    count++;
    Set<K> keysNew = evictionMap.get(count);
    if (keysNew == null) {
      keysNew = new LinkedHashSet<K>();
      evictionMap.put(count, keysNew);
    }
    keysNew.add(key);
  }
  
  @Override
  public void set(K key, V value) {
    if (dataMap.containsKey(key)) {
      return;
    }
    if (capacity == dataMap.size()) { // Cache Full
      removeLeastFrequent();
    }
    MutableLong count = new MutableLong(1L);
    Pair<V,MutableLong> data = new Pair<V,MutableLong>(value, count);
    dataMap.put(key, data);
    
    Long countKey = 1L;
    Set<K> keys = evictionMap.get(countKey);
    if (keys == null) {
      keys = new LinkedHashSet<K>();
      evictionMap.put(countKey, keys);
    }
    keys.add(key);
    
  }
  
  private void removeLeastFrequent() {
    Long key = evictionMap.firstKey();
    Set<K> values = evictionMap.get(key);
    Iterator<K> it = values.iterator();
    K keyToBeRemoved = it.next();
    values.remove(keyToBeRemoved);
    if (values.isEmpty()) {
      evictionMap.remove(key);
    }
    dataMap.remove(keyToBeRemoved);
    evictionCount++;
    
  }
  
  @Override
  public long size() {
    return dataMap.size();
  }
  
  @Override
  public boolean contains(K key) {
    return dataMap.containsKey(key);
  }
  
}
