# encoding: UTF-8

require 'test_helper'
require 'govspeak_test_helper'

require 'ostruct'

class GovspeakTest < Minitest::Test
  include GovspeakTestHelper

  test_given_govspeak "{button start cross-domain-tracking:UA-23066786-5}[Start now](https://www.registertovote.service.gov.uk/register-to-vote/start){/button}" do
    assert_html_output '<p><a role="button" class="button button-start" href="https://www.registertovote.service.gov.uk/register-to-vote/start" data-module="cross-domain-tracking" data-tracking-code="UA-23066786-5" data-tracking-name="govspeakButtonTracker">Start now</a></p>'
    assert_text_output "Start now"
  end

  # The same as above but with line breaks
  test_given_govspeak "{button start cross-domain-tracking:UA-23066786-5}\n\n\n[Start now](https://www.registertovote.service.gov.uk/register-to-vote/start)\n\n\n{/button}" do
    assert_html_output '<p><a role="button" class="button button-start" href="https://www.registertovote.service.gov.uk/register-to-vote/start" data-module="cross-domain-tracking" data-tracking-code="UA-23066786-5" data-tracking-name="govspeakButtonTracker">Start now</a></p>'
    assert_text_output "Start now"
  end

  test_given_govspeak "{button cross-domain-tracking:UA-23066786-5}[Start now](https://www.registertovote.service.gov.uk/register-to-vote/start){/button}" do
    assert_html_output '<p><a role="button" class="button" href="https://www.registertovote.service.gov.uk/register-to-vote/start" data-module="cross-domain-tracking" data-tracking-code="UA-23066786-5" data-tracking-name="govspeakButtonTracker">Start now</a></p>'
    assert_text_output "Start now"
  end

  test_given_govspeak "{button start}[Start now](https://www.registertovote.service.gov.uk/register-to-vote/start){/button}" do
    assert_html_output '<p><a role="button" class="button button-start" href="https://www.registertovote.service.gov.uk/register-to-vote/start">Start now</a></p>'
    assert_text_output "Start now"
  end

  test_given_govspeak "{button}[Start now](https://www.registertovote.service.gov.uk/register-to-vote/start){/button}" do
    assert_html_output '<p><a role="button" class="button" href="https://www.registertovote.service.gov.uk/register-to-vote/start">Start now</a></p>'
    assert_text_output "Start now"
  end

  # Test other text outputs
  test_given_govspeak "{button}[Something else](https://www.registertovote.service.gov.uk/register-to-vote/start){/button}" do
    assert_html_output '<p><a role="button" class="button" href="https://www.registertovote.service.gov.uk/register-to-vote/start">Something else</a></p>'
    assert_text_output "Something else"
  end

  # Test that nothing renders when not given a link
  test_given_govspeak "{button}I shouldn't render a button{/button}" do
    assert_html_output '<p>{button}I shouldn’t render a button{/button}</p>'
  end

  test_given_govspeak "Text before the button with line breaks \n\n\n{button}[Start Now](http://www.gov.uk){/button}\n\n\n test after the button" do
    assert_html_output %{
      <p>Text before the button with line breaks</p>

      <p><a role="button" class="button" href="http://www.gov.uk">Start Now</a></p>

      <p>test after the button</p>
    }
    assert_text_output "Text before the button with line breaks Start Now test after the button"
  end

  # Test README examples
  test_given_govspeak "{button}[Continue](https://gov.uk/random){/button}" do
    assert_html_output '<p><a role="button" class="button" href="https://gov.uk/random">Continue</a></p>'
    assert_text_output "Continue"
  end

  test_given_govspeak "{button start}[Start Now](https://gov.uk/random){/button}" do
    assert_html_output '<p><a role="button" class="button button-start" href="https://gov.uk/random">Start Now</a></p>'
    assert_text_output "Start Now"
  end

  test_given_govspeak "{button start cross-domain-tracking:UA-XXXXXX-Y}[Start Now](https://example.com/external-service/start-now){/button}" do
    assert_html_output '<p><a role="button" class="button button-start" href="https://example.com/external-service/start-now" data-module="cross-domain-tracking" data-tracking-code="UA-XXXXXX-Y" data-tracking-name="govspeakButtonTracker">Start Now</a></p>'
    assert_text_output "Start Now"
  end

  # Test indenting button govspeak results in no render, useful in guides
  test_given_govspeak "    {button start cross-domain-tracking:UA-XXXXXX-Y}[Example](https://example.com/external-service/start-now){/button}" do
    assert_html_output %{
      <pre><code>{button start cross-domain-tracking:UA-XXXXXX-Y}[Example](https://example.com/external-service/start-now){/button}
      </code></pre>
    }
  end

  # Make sure button renders when typical linebreaks are before it, seen in publishing applications
  test_given_govspeak "{button}[Line breaks](https://gov.uk/random){/button}\r\n\r\n{button}[Continue](https://gov.uk/random){/button}\r\n\r\n{button}[Continue](https://gov.uk/random){/button}" do
    assert_html_output %{
      <p><a role="button" class="button" href="https://gov.uk/random">Line breaks</a></p>

      <p><a role="button" class="button" href="https://gov.uk/random">Continue</a></p>

      <p><a role="button" class="button" href="https://gov.uk/random">Continue</a></p>
    }
  end

  test_given_govspeak "{button}[More line breaks](https://gov.uk/random){/button}\n\n{button}[Continue](https://gov.uk/random){/button}\n\n{button}[Continue](https://gov.uk/random){/button}" do
    assert_html_output %{
      <p><a role="button" class="button" href="https://gov.uk/random">More line breaks</a></p>

      <p><a role="button" class="button" href="https://gov.uk/random">Continue</a></p>

      <p><a role="button" class="button" href="https://gov.uk/random">Continue</a></p>
    }
  end

  test_given_govspeak %{
    ## Register to vote

    Introduction text about the service.

    lorem lorem lorem
    lorem lorem lorem

    {button start}[Start Now](https://gov.uk/random){/button}

    lorem lorem lorem
    lorem lorem lorem
  } do
    assert_html_output %{
      <h2 id="register-to-vote">Register to vote</h2>

      <p>Introduction text about the service.</p>

      <p>lorem lorem lorem
      lorem lorem lorem</p>

      <p><a role="button" class="button button-start" href="https://gov.uk/random">Start Now</a></p>

      <p>lorem lorem lorem
      lorem lorem lorem</p>
    }
  end
end