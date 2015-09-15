require "spec_helper_acceptance"
describe "profiles::motd" do
  it "should bloody work" do

    exit_code = apply_manifest('include profiles::motd', :catch_failures => true).exit_code
    expect(exit_code).to_not eq(1) # generic error code - cant be right...
    expect(exit_code).to_not eq(4) # failures
    expect(exit_code).to_not eq(6) # failures and changes
  end
end
