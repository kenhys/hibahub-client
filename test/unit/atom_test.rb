# frozen_string_literal: true

require 'tmpdir'
require_relative '../../lib/yomou/atom'

class AtomTest < Test::Unit::TestCase
  setup do
  end

  sub_test_case "type" do
    def test_directory
      sandbox do
        output = StringIO.new
        atom_path = allnovel_path
        downloader = Yomou::Atom::Downloader.new(output: output)
        downloader.download
        assert_equal(true, File.exist?(allnovel_path))
      end
    end
  end

  private

  def allnovel_path
    relative_path = Time.now.strftime('atomapi/%Y/%m/%d/allnovel-%H%M.Atom.yaml.xz')
    File.join(ENV['YOMOU_HOME'], relative_path)
  end
end
