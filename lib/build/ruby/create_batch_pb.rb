# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: create_batch.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("create_batch.proto", :syntax => :proto2) do
    add_message "ipc.CreateBatch" do
      required :user_id, :int32, 1
      required :correlation_id, :int32, 2
      required :uuid, :string, 3
      required :type, :string, 4
      required :data, :message, 5, "ipc.CreateBatch.Data"
    end
    add_message "ipc.CreateBatch.Data" do
      required :iteration, :string, 1
    end
  end
end

module Ipc
  CreateBatch = Google::Protobuf::DescriptorPool.generated_pool.lookup("ipc.CreateBatch").msgclass
  CreateBatch::Data = Google::Protobuf::DescriptorPool.generated_pool.lookup("ipc.CreateBatch.Data").msgclass
end