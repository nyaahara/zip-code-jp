# -*- coding: utf-8 -*-
require 'json'
require 'zip_code_jp/export'
require 'zip_code_jp/address'

module ZipCodeJp
  DATA_DIR = File.dirname(__FILE__) + '/../data'

  module_function
  def export_json
    ZipCodeJp::Export.execute
  end

  def find(zip_code)
    zip_code = zip_code.gsub(/-/, '')
    json_file = DATA_DIR + '/zip_code/' + zip_code.slice(0,3) + '.json'
    if (File.exists?(json_file))
      data = JSON.parse(File.open(json_file).read)
      address_data = data[zip_code.slice(3,4)]

      if address_data.instance_of?(Array)
        results = []
        address_data.each do |a|
          results.push ZipCodeJp::Address.new(a)
        end
        return results
      end

      return address_data ? ZipCodeJp::Address.new(address_data) : false
    end
    return false
  end

  def all
    json_files = Dir.glob("#{DATA_DIR}/zip_code/*.json").sort
    addresses = json_files.map { |p| JSON.parse(File.open(p).read).values }.flatten
    addresses.map { |address| ZipCodeJp::Address.new(address) }
  end
end
