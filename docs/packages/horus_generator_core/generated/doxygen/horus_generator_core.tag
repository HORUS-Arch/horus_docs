<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.8">
  <compound kind="file">
    <name>generator.hpp</name>
    <path>include/horus_generator_core/</path>
    <filename>generator_8hpp.html</filename>
    <class kind="class">horus_generator_core::Generator</class>
  </compound>
  <compound kind="class">
    <name>horus_generator_core::Generator</name>
    <filename>classhorus__generator__core_1_1Generator.html</filename>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>configure</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>a186b7873eed1152d97480a06e37311a3</anchor>
      <arglist>(const NodePtr &amp;node, const std::string &amp;name)=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>activate</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>a8ba4fe18eef6b597af8a554c6fa97a0e</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>deactivate</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>ae533309152199cd26ba7048d5763ba2b</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual void</type>
      <name>reset</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>a29b0093aed724a059d09a9de93ae39a7</anchor>
      <arglist>()=0</arglist>
    </member>
    <member kind="function" virtualness="pure">
      <type>virtual std::vector&lt; double &gt;</type>
      <name>update</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>aed4e78d5e794b33931aaab8739787cea</anchor>
      <arglist>(const rclcpp::Time &amp;time, const rclcpp::Duration &amp;period)=0</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual bool</type>
      <name>finished</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>a2d142582f4e25f6cc24f542aeeffcf36</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual double</type>
      <name>progress</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>aab97360799bfef185b3789e98428f3e8</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::vector&lt; std::string &gt;</type>
      <name>jointNames</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>ad3fbc23d20d533b7278714729b49241f</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual std::string</type>
      <name>quantity</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>a42aba85d6daebc7479a884d46362d316</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function" virtualness="virtual">
      <type>virtual void</type>
      <name>setSpeedScale</name>
      <anchorfile>classhorus__generator__core_1_1Generator.html</anchorfile>
      <anchor>aac97a06d1cdf642b3bb1b3993cc724c4</anchor>
      <arglist>(double)</arglist>
    </member>
  </compound>
</tagfile>
