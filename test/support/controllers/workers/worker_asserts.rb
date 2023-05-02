module WorkerAsserts
  def worker_response_asserts
    worker = Worker.find(response_data['id'])

    assert_subset response_data.keys, worker_valid_keys
    assert_equal worker.id, response_data['id']
    assert_equal worker.name, response_data['name']
    assert_equal worker.id_number, response_data['id_number']
  end
end
