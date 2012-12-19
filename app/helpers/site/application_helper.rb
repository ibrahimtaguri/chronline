module Site::ApplicationHelper

  def advertisement(zone)
    <<EOS
<script type='text/javascript'><!--// <![CDATA[
    OA_show('#{zone.to_s}');
// ]]> --></script>
EOS
      .html_safe
  end

end