# frozen_string_literal: true

module AssertColumnMatch
  def assert_column_match(column, expected_columns, model_name)
    assert expected_columns[column.name.to_sym], "Unexpected column '#{column.name}' in #{model_name} model"
    assert_equal expected_columns[column.name.to_sym][0],
                 column.type, "Unexpected column type for '#{column.name}' in #{model_name} model"
    assert_equal expected_columns[column.name.to_sym][1],
                 column.null, "Unexpected nullability for '#{column.name}' in #{model_name} model"
  end
end
