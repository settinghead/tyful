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
package org.apache.mahout.math;

import com.google.gson.Gson;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

import java.lang.reflect.Type;

public class JsonMatrixAdapter implements JsonSerializer<Matrix>, JsonDeserializer<Matrix> {

  public static final String CLASS = "class";
  public static final String MATRIX = "matrix";

  public JsonElement serialize(Matrix src, Type typeOfSrc,
                               JsonSerializationContext context) {
    JsonObject obj = new JsonObject();
    obj.add(CLASS, new JsonPrimitive(src.getClass().getName()));
    obj.add(MATRIX, context.serialize(src));
    return obj;
  }

  public Matrix deserialize(JsonElement json, Type typeOfT,
                            JsonDeserializationContext context) {
    JsonObject obj = json.getAsJsonObject();
    String klass = obj.get(CLASS).getAsString();
    ClassLoader ccl = Thread.currentThread().getContextClassLoader();
    Class<? extends Matrix> cl;
    try {
      cl = (Class<? extends Matrix>) ccl.loadClass(klass);
    } catch (ClassNotFoundException e) {
      throw new JsonParseException(e);
    }

    if (obj.get(MATRIX).isJsonPrimitive()) {
      String matrix = obj.get(MATRIX).getAsString();
      Gson gson = AbstractMatrix.gson();
      return gson.fromJson(matrix, cl);
    } else {
      return context.deserialize(obj.get(MATRIX), cl);
    }
  }

}
