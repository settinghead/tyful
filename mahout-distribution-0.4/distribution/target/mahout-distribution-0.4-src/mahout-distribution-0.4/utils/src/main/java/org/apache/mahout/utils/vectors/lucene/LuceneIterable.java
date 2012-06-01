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

package org.apache.mahout.utils.vectors.lucene;

import java.io.IOException;
import java.util.Collections;
import java.util.Iterator;

import com.google.common.base.Preconditions;
import org.apache.lucene.document.FieldSelector;
import org.apache.lucene.document.SetBasedFieldSelector;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.TermDocs;
import org.apache.mahout.math.NamedVector;
import org.apache.mahout.math.Vector;

/**
 * A LuceneIterable is an Iterable&lt;Vector&gt; that uses a Lucene index as the source for creating the
 * {@link Vector}. The Field used to create the Vector currently must have Term Vectors stored for it.
 */
public class LuceneIterable implements Iterable<Vector> {

  public static final double NO_NORMALIZING = -1.0;

  private final IndexReader indexReader;
  private final String field;
  private final String idField;
  private final FieldSelector idFieldSelector;
  
  private final VectorMapper mapper;
  private double normPower = NO_NORMALIZING;

  public LuceneIterable(IndexReader reader, String idField, String field, VectorMapper mapper) {
    this(reader, idField, field, mapper, NO_NORMALIZING);
  }
  
  /**
   * Produce a LuceneIterable that can create the Vector plus normalize it.
   * 
   * @param reader
   *          The {@link org.apache.lucene.index.IndexReader} to read the documents from.
   * @param idField
   *          - The Field containing the id. May be null
   * @param field
   *          The field to use for the Vector
   * @param mapper
   *          The {@link org.apache.mahout.utils.vectors.lucene.VectorMapper} for creating
   *          {@link org.apache.mahout.math.Vector}s from Lucene's TermVectors.
   * @param normPower
   *          The normalization value. Must be greater than or equal to 0 or equal to {@link #NO_NORMALIZING}
   */
  public LuceneIterable(IndexReader reader,
                        String idField,
                        String field,
                        VectorMapper mapper,
                        double normPower) {
    Preconditions.checkArgument(normPower == NO_NORMALIZING || normPower >= 0,
        "If specified normPower must be nonnegative", normPower);
    idFieldSelector = new SetBasedFieldSelector(Collections.singleton(idField), Collections.<String>emptySet());
    this.indexReader = reader;
    this.idField = idField;
    this.field = field;
    this.mapper = mapper;
    this.normPower = normPower;
  }
  
  @Override
  public Iterator<Vector> iterator() {
    try {
      return new TDIterator();
    } catch (IOException e) {
      throw new IllegalStateException(e);
    }
  }
  
  private final class TDIterator implements Iterator<Vector> {
    private final TermDocs termDocs;
    
    private TDIterator() throws IOException {
      // term docs(null) is a better way of iterating all the docs in Lucene
      this.termDocs = indexReader.termDocs(null);
    }
    
    @Override
    public boolean hasNext() {
      // TODO this doesn't work with the Iterator contract -- hasNext() cannot have a side effect
      try {
        return termDocs.next();
      } catch (IOException e) {
        throw new IllegalStateException(e);
      }
    }
    
    @Override
    public Vector next() {
      Vector result;
      int doc = termDocs.doc();
      //
      try {
        indexReader.getTermFreqVector(doc, field, mapper);
        mapper.setDocumentNumber(doc);
        result = mapper.getVector();
        if (result == null) {
          return null;
        }
        String name;
        if (idField != null) {
          name = indexReader.document(doc, idFieldSelector).get(idField);
        } else {
          name = String.valueOf(doc);
        }
        if (normPower == NO_NORMALIZING) {
          result = new NamedVector(result, name);
        } else {
          result = new NamedVector(result.normalize(normPower), name);
        }
      } catch (IOException e) {
        // Log?
        throw new IllegalStateException(e);
      }
      
      return result;
    }
    
    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }
    
  }
  
}
