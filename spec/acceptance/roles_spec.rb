require "spec_helper_acceptance"

def test_class(classname)
  describe classname do
    it "include #{classname} should work" do
      pp = <<-EOS
        # simulate puppet_enterprise
        include puppet_enterprise

        # the test itself
        include #{classname}
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end
  end
end

def classnames(dir)
  classnames = []
  Dir.glob("#{dir}/manifests/**/*.pp") do |manifest|
    if manifest =~ /manifests\/init\.pp/
      # name of module
      classname = File.basename(dir)
    else
      # name of file
      classname = File.basename(dir) + manifest.gsub("#{dir}/manifests", "").gsub("/", "::").gsub("\.pp","")
    end
    classnames.push(classname)
  end
  return classnames
end

# test all roles - remember this scan is done on THIS computer not the beaker instance!
role_classes = classnames("site/roles")
if role_classes then
  role_classes.each do |role_class|
    test_class(role_class)
  end
end



#describe "profiles::motd" do
#  it "should bloody work" do
#
#    exit_code = apply_manifest('include profiles::motd', :catch_failures => true).exit_code
#    expect(exit_code).to_not eq(1) # generic error code - cant be right...
#    expect(exit_code).to_not eq(4) # failures
#    expect(exit_code).to_not eq(6) # failures and changes
#  end
#end
