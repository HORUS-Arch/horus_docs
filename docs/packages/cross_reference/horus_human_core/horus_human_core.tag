<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.8">
  <compound kind="file">
    <name>calibration_plugin.hpp</name>
    <path>include/horus_human_core/</path>
    <filename>calibration__plugin_8hpp.html</filename>
    <class kind="class">horus_human_core::CalibrationPlugin</class>
  </compound>
  <compound kind="file">
    <name>calibration_store.hpp</name>
    <path>include/horus_human_core/</path>
    <filename>calibration__store_8hpp.html</filename>
    <class kind="struct">horus_human_core::CalibrationEntry</class>
    <class kind="class">horus_human_core::CalibrationStore</class>
  </compound>
  <compound kind="file">
    <name>channel_node.hpp</name>
    <path>include/horus_human_core/</path>
    <filename>channel__node_8hpp.html</filename>
    <includes id="calibration__plugin_8hpp" name="calibration_plugin.hpp" local="yes" import="no" module="no" objc="no">horus_human_core/calibration_plugin.hpp</includes>
    <includes id="calibration__store_8hpp" name="calibration_store.hpp" local="yes" import="no" module="no" objc="no">horus_human_core/calibration_store.hpp</includes>
    <class kind="class">horus_human_core::ChannelNode</class>
  </compound>
  <compound kind="struct">
    <name>horus_human_core::CalibrationEntry</name>
    <filename>structhorus__human__core_1_1CalibrationEntry.html</filename>
    <member kind="variable">
      <type>std::string</type>
      <name>unit</name>
      <anchorfile>structhorus__human__core_1_1CalibrationEntry.html</anchorfile>
      <anchor>a3192b874336511a60fd18a0888added4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>stamp</name>
      <anchorfile>structhorus__human__core_1_1CalibrationEntry.html</anchorfile>
      <anchor>a9b97c262b191a3544841ab7d8f93a516</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::string</type>
      <name>path</name>
      <anchorfile>structhorus__human__core_1_1CalibrationEntry.html</anchorfile>
      <anchor>ab8e6355078c5b433150e6675be817966</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_human_core::CalibrationPlugin</name>
    <filename>classhorus__human__core_1_1CalibrationPlugin.html</filename>
    <templarg>class MsgT</templarg>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>configure</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>a8d411ae09c9e2a2475dcceb383609dba</anchor>
      <arglist>(const NodePtr &amp;node, const std::string &amp;name, const std::vector&lt; std::string &gt; &amp;units)=0</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>defaultDuration</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>a9efdc8148283993544190168f4dce60f</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>begin</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>a4cfa431e1d28d1b325a1d1f691a4b829</anchor>
      <arglist>(const std::string &amp;unit)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>add</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>a86627e6a1104d74382ccc704ea38f879</anchor>
      <arglist>(const std::string &amp;unit, const MsgT &amp;raw)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual bool</type>
      <name>finish</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>ad2a49a5d1de943d4da284e6a7a68c5b0</anchor>
      <arglist>(const std::string &amp;unit, YAML::Node &amp;out, std::string &amp;summary)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual bool</type>
      <name>load</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>ad2bda94d7fc38c675e14b4808f10447d</anchor>
      <arglist>(const std::string &amp;unit, const YAML::Node &amp;data)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual bool</type>
      <name>calibrated</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>aacc85ccaecff7160554cf89892830777</anchor>
      <arglist>(const std::string &amp;unit) const =0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>apply</name>
      <anchorfile>classhorus__human__core_1_1CalibrationPlugin.html</anchorfile>
      <anchor>a47101c0c7e30fc2eb2136c26ec93454f</anchor>
      <arglist>(const std::string &amp;unit, MsgT &amp;msg) const =0</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_human_core::CalibrationStore</name>
    <filename>classhorus__human__core_1_1CalibrationStore.html</filename>
    <member kind="function">
      <type></type>
      <name>CalibrationStore</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>aedbb37658cc881e52fefb40d5d549a21</anchor>
      <arglist>(const std::string &amp;data_root)</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>save</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>a7c258388ca40ad9e03e5a5fb840645c0</anchor>
      <arglist>(const std::string &amp;subject, const std::string &amp;node, const std::string &amp;unit, const std::string &amp;plugin, const YAML::Node &amp;data) const</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; CalibrationEntry &gt;</type>
      <name>list</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>a3b54477af7c6f26d9236a6d524e0a5d9</anchor>
      <arglist>(const std::string &amp;subject, const std::string &amp;node) const</arglist>
    </member>
    <member kind="function">
      <type>std::optional&lt; std::string &gt;</type>
      <name>latest</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>afeddeb24ad8cfa3e2766124b28e258a1</anchor>
      <arglist>(const std::string &amp;subject, const std::string &amp;node, const std::string &amp;unit) const</arglist>
    </member>
    <member kind="function">
      <type>const std::string &amp;</type>
      <name>root</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>a6a44df43b1bf6f9535bfbd170f1a6b81</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static YAML::Node</type>
      <name>read</name>
      <anchorfile>classhorus__human__core_1_1CalibrationStore.html</anchorfile>
      <anchor>a446e1888c20ca8c905e86b5077cb3607</anchor>
      <arglist>(const std::string &amp;path)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_human_core::ChannelNode</name>
    <filename>classhorus__human__core_1_1ChannelNode.html</filename>
    <templarg>class MsgT</templarg>
    <member kind="function">
      <type></type>
      <name>ChannelNode</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>aa26a2d6292d7d7f39b5c563b71d62058</anchor>
      <arglist>(const std::string &amp;name, const rclcpp::NodeOptions &amp;options, const std::string &amp;plugin_package, const std::string &amp;plugin_base)</arglist>
    </member>
    <member kind="function">
      <type>CallbackReturn</type>
      <name>on_configure</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a18c979395c59478e97bfbda6c9322a07</anchor>
      <arglist>(const rclcpp_lifecycle::State &amp;) override</arglist>
    </member>
    <member kind="function">
      <type>CallbackReturn</type>
      <name>on_activate</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>ac01b0cdda7c9b3af379e2f50ff137125</anchor>
      <arglist>(const rclcpp_lifecycle::State &amp;) override</arglist>
    </member>
    <member kind="function">
      <type>CallbackReturn</type>
      <name>on_deactivate</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>adf9f9cc4f2a98bc8a46735694b5fff86</anchor>
      <arglist>(const rclcpp_lifecycle::State &amp;) override</arglist>
    </member>
    <member kind="function">
      <type>CallbackReturn</type>
      <name>on_cleanup</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a21a0d1930fd5d23b588ba6d6835ca0bb</anchor>
      <arglist>(const rclcpp_lifecycle::State &amp;) override</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual bool</type>
      <name>validateChannel</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a365fd6c79c0535c9a74cf6a63291c8cc</anchor>
      <arglist>(const std::string &amp;, std::string &amp;)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="pure">
      <type>virtual void</type>
      <name>configureOutputs</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a466fe24ee1100480a1558611dc1445c1</anchor>
      <arglist>(const std::vector&lt; std::string &gt; &amp;channels)=0</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="pure">
      <type>virtual void</type>
      <name>activateOutputs</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a155a753d2391e3752d62b4a99a61a948</anchor>
      <arglist>(bool active)=0</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="pure">
      <type>virtual void</type>
      <name>cleanupOutputs</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>ae1fee3345d3906f0867de19fd907e476</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="virtual">
      <type>virtual void</type>
      <name>condition</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a364eba3c9502e946e4cb528acbd3cc77</anchor>
      <arglist>(const std::string &amp;, MsgT &amp;)</arglist>
    </member>
    <member kind="function" protection="protected" virtualness="pure">
      <type>virtual void</type>
      <name>publish</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a73f726d5852bd68c1ab07c62ddc7827f</anchor>
      <arglist>(const std::string &amp;channel, const MsgT &amp;msg)=0</arglist>
    </member>
    <member kind="function" protection="protected">
      <type>T</type>
      <name>declareIfMissing</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a8d4b29f99ac574d5fa6d05b8236cc067</anchor>
      <arglist>(const std::string &amp;name, const T &amp;fallback)</arglist>
    </member>
    <member kind="variable" protection="protected">
      <type>std::vector&lt; std::string &gt;</type>
      <name>channels_</name>
      <anchorfile>classhorus__human__core_1_1ChannelNode.html</anchorfile>
      <anchor>a0638b606d54016d6bfeae516f3a4bd87</anchor>
      <arglist></arglist>
    </member>
  </compound>
</tagfile>
