<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.8">
  <compound kind="file">
    <name>manual.hpp</name>
    <path>include/horus_generator_pattern/</path>
    <filename>manual_8hpp.html</filename>
    <class kind="class">horus_generator_pattern::Manual</class>
  </compound>
  <compound kind="file">
    <name>pattern.hpp</name>
    <path>include/horus_generator_pattern/</path>
    <filename>pattern_8hpp.html</filename>
    <class kind="struct">horus_generator_pattern::Signal</class>
    <class kind="class">horus_generator_pattern::Pattern</class>
  </compound>
  <compound kind="file">
    <name>waypoints.hpp</name>
    <path>include/horus_generator_pattern/</path>
    <filename>waypoints_8hpp.html</filename>
    <class kind="class">horus_generator_pattern::Waypoints</class>
  </compound>
  <compound kind="class">
    <name>horus_generator_pattern::Manual</name>
    <filename>classhorus__generator__pattern_1_1Manual.html</filename>
    <base>horus_generator_core::Generator</base>
    <member kind="function">
      <type>void</type>
      <name>setTargets</name>
      <anchorfile>classhorus__generator__pattern_1_1Manual.html</anchorfile>
      <anchor>a1154b727b1e1fa74b1d5ec5bc767d82b</anchor>
      <arglist>(const sensor_msgs::msg::JointState &amp;msg, const rclcpp::Time &amp;stamp)</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_generator_pattern::Pattern</name>
    <filename>classhorus__generator__pattern_1_1Pattern.html</filename>
    <base>horus_generator_core::Generator</base>
    <member kind="function">
      <type>void</type>
      <name>configure</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>aafbcef9fa232b1cf88902db218f83710</anchor>
      <arglist>(const horus_generator_core::NodePtr &amp;node, const std::string &amp;name) override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>activate</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>a88e16840e66e01253c2ec45127d3f702</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>deactivate</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>a8cb440940b9a2368f2e103f280ac1cdb</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>reset</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>a30bbdc462266cfbcb1a6b06dbf8a34c3</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; double &gt;</type>
      <name>update</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>a667f982589795126bb03719ac31e5500</anchor>
      <arglist>(const rclcpp::Time &amp;time, const rclcpp::Duration &amp;period) override</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>finished</name>
      <anchorfile>classhorus__generator__pattern_1_1Pattern.html</anchorfile>
      <anchor>aa68037072e42b5cb00dea63caf6d9657</anchor>
      <arglist>() const override</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>horus_generator_pattern::Signal</name>
    <filename>structhorus__generator__pattern_1_1Signal.html</filename>
    <member kind="variable">
      <type>std::string</type>
      <name>type</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>a91d4ed906699ab993c5566f674bd9995</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>min</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>a5afca66242d006875d2e87f0a2553ce6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>max</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>ab543da004fd8fdef5ea86bc89a41acb6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>middle</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>a64e6bcf89457d12bf6a4757b02e7ad1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>amplitude</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>a8746b51c4ee9520a77276a69aab96bd3</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>std::vector&lt; double &gt;</type>
      <name>custom</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>a091632917d22c68f1611b0767b594c8a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>double</type>
      <name>phase_offset</name>
      <anchorfile>structhorus__generator__pattern_1_1Signal.html</anchorfile>
      <anchor>af1ef263d1f9267395686a18936b8654b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_generator_pattern::Waypoints</name>
    <filename>classhorus__generator__pattern_1_1Waypoints.html</filename>
    <base>horus_generator_core::Generator</base>
    <member kind="function">
      <type>void</type>
      <name>configure</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>adefaacf84d5b54e3dff13f7b31b5cf52</anchor>
      <arglist>(const horus_generator_core::NodePtr &amp;node, const std::string &amp;name) override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>activate</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>af940546d59ed2022ed8224b2dfb94765</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>deactivate</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>a277c923f89d60f30b05f15428ebdc2e0</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>reset</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>a07b34f64e4091ea17d7dd44aa3046673</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; double &gt;</type>
      <name>update</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>aee34aff08a0f1cb57b044463dbb0f640</anchor>
      <arglist>(const rclcpp::Time &amp;time, const rclcpp::Duration &amp;period) override</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>finished</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>a8b16859483807126b87cd499bb520c57</anchor>
      <arglist>() const override</arglist>
    </member>
    <member kind="function">
      <type>double</type>
      <name>progress</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>aac2e13af9f5083b285e885bb64b0ebf0</anchor>
      <arglist>() const override</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; std::string &gt;</type>
      <name>jointNames</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>ace2dcca71f50ee0e984d2878955e7065</anchor>
      <arglist>() const override</arglist>
    </member>
    <member kind="function">
      <type>std::string</type>
      <name>quantity</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>ab56ea98d0e555483d18543e73a2c16a2</anchor>
      <arglist>() const override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>setSpeedScale</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>ae90b24779ef7a314900799d9ba0a0aa8</anchor>
      <arglist>(double scale) override</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; double &gt;</type>
      <name>sampleRate</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>a66694d7ff0f1f2b83010d861cd1b35d0</anchor>
      <arglist>(double t) const</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; double &gt;</type>
      <name>sample</name>
      <anchorfile>classhorus__generator__pattern_1_1Waypoints.html</anchorfile>
      <anchor>a7aa9f0fcb5e423cb3a9b13479e2859d2</anchor>
      <arglist>(double t) const</arglist>
    </member>
  </compound>
</tagfile>
