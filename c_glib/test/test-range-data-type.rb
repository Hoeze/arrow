# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

class TestRangeDataType < Test::Unit::TestCase
  def setup
    @value_type = Arrow::Int32DataType.new
    @data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::LEFT, true)
  end

  def test_id
    assert_equal(Arrow::Type::EXTENSION, @data_type.id)
  end

  def test_name
    assert_equal(["extension", "arrow.range"],
                 [@data_type.name, @data_type.extension_name])
  end

  def test_value_type
    assert_equal(@value_type, @data_type.value_type)
  end

  def test_closed
    assert_equal(Arrow::RangeClosed::LEFT, @data_type.closed)
  end

  def test_to_s
    assert do
      @data_type.to_s.start_with?("extension<arrow.range")
    end
  end

  def test_closed_left
    data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::LEFT, true)
    assert_equal(Arrow::RangeClosed::LEFT, data_type.closed)
  end

  def test_closed_right
    data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::RIGHT, true)
    assert_equal(Arrow::RangeClosed::RIGHT, data_type.closed)
  end

  def test_closed_both
    data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::BOTH, true)
    assert_equal(Arrow::RangeClosed::BOTH, data_type.closed)
  end

  def test_closed_neither
    data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::NEITHER, true)
    assert_equal(Arrow::RangeClosed::NEITHER, data_type.closed)
  end

  def test_allow_unbounded_false
    data_type = Arrow::RangeDataType.new(@value_type, Arrow::RangeClosed::BOTH, false)
    assert_equal("arrow.range", data_type.extension_name)
  end

  def test_converted_from_cpp
    schema = Arrow::Schema.new([Arrow::Field.new("range", @data_type)])
    converted = schema.fields[0].data_type
    assert_equal([@data_type, Arrow::RangeClosed::LEFT, @value_type],
                 [converted, converted.closed, converted.value_type])
  end
end
