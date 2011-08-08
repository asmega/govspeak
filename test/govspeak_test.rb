require 'test_helper'

class GovspeakTest < Test::Unit::TestCase
  
  test "simple smoke-test" do
    rendered =  Govspeak::Document.new("*this is markdown*").to_html
    assert_equal "<p><em>this is markdown</em></p>\n", rendered
  end
  
  test "simple block extension" do
    rendered =  Govspeak::Document.new("this \n{::reverse}\n*is*\n{:/reverse}\n markdown").to_html
    assert_equal "<p>this </p>\n\n<p><em>si</em></p>\n\n<p>markdown</p>\n", rendered
  end
  
  test "govspark extensions" do
    markdown_regression_tests = [
{
input: "^ I am very informational ^",
output: "<div class=\"application-notice info-notice\">
<p>I am very informational</p>
</div>"
},
{
input: "^ I am very informational",
output: "<div class=\"application-notice info-notice\">
<p>I am very informational</p>
</div>"
},
{
input: "@ I am very important @",
output: "<h3 class=\"advisory\"><span>I am very important</span></h3>"
}, {
input: "% I am very helpful %",
output:  "<div class=\"application-notice help-notice\">
<p>I am very helpful</p>
</div>"
}, {
input: "## Hello ##\n\n% I am very helpful %\r\n### Young Workers ###\n\n",
output:  "<h2 id=\"hello\">Hello</h2>
<div class=\"application-notice help-notice\">
<p>I am very helpful</p>
</div>

<h3 id=\"young-workers\">Young Workers</h3>"
},
{
input: "% I am very helpful",
output: "<div class=\"application-notice help-notice\">
<p>I am very helpful</p>
</div>"
},
{
  input: "This is a [link](http://www.google.com) isn't it?",
  output: '<p>This is a <a href="http://www.google.com">link</a> isn&rsquo;t it?</p>'
}  ,
  {
    input: "This is a [link with an at sign in it](http://www.google.com/@dg/@this) isn't it?",
    output: '<p>This is a <a href="http://www.google.com/@dg/@this">link with an at sign in it</a> isn&rsquo;t it?</p>'
  }
]
  
  markdown_regression_tests.each do |t|
    rendered = Govspeak::Document.new(t[:input]).to_html
    assert_equal t[:output].strip, rendered.strip
  end
  
  end
  
  test "devolved markdown sections" do
    input =  ":scotland: I am very devolved \n and very scottish \n:/scotland:"
    output = '<div class="devolved-content scotland">
<p class="devolved-header">This section applies to Scotland</p>
<div class="devolved-body"><p>I am very devolved 
 and very scottish</p>
</div>
</div>
'
    assert_equal output, Govspeak::Document.new(input).to_html
  end
  
end