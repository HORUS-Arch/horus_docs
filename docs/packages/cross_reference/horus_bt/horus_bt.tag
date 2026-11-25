<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.9.8">
  <compound kind="file">
    <name>calibrate_node.hpp</name>
    <path>include/horus_bt/</path>
    <filename>calibrate__node_8hpp.html</filename>
    <includes id="node__ptr_8hpp" name="node_ptr.hpp" local="yes" import="no" module="no" objc="no">horus_bt/node_ptr.hpp</includes>
    <class kind="class">horus_bt::CalibrateNode</class>
  </compound>
  <compound kind="file">
    <name>condition_nodes.hpp</name>
    <path>include/horus_bt/</path>
    <filename>condition__nodes_8hpp.html</filename>
    <includes id="node__ptr_8hpp" name="node_ptr.hpp" local="yes" import="no" module="no" objc="no">horus_bt/node_ptr.hpp</includes>
    <class kind="struct">horus_bt::detail::LeafExecutor</class>
    <class kind="class">horus_bt::IsAtPoseNode</class>
    <class kind="class">horus_bt::IsHealthyNode</class>
    <class kind="class">horus_bt::WaitForMessageNode</class>
  </compound>
  <compound kind="file">
    <name>node_ptr.hpp</name>
    <path>include/horus_bt/</path>
    <filename>node__ptr_8hpp.html</filename>
  </compound>
  <compound kind="file">
    <name>system_nodes.hpp</name>
    <path>include/horus_bt/</path>
    <filename>system__nodes_8hpp.html</filename>
    <includes id="node__ptr_8hpp" name="node_ptr.hpp" local="yes" import="no" module="no" objc="no">horus_bt/node_ptr.hpp</includes>
    <class kind="class">horus_bt::EmergencyStopNode</class>
    <class kind="class">horus_bt::ServiceLeaf</class>
    <class kind="class">horus_bt::StartRecordingNode</class>
    <class kind="class">horus_bt::StopRecordingNode</class>
    <class kind="class">horus_bt::AddTrialNoteNode</class>
    <class kind="class">horus_bt::SetSpeedScaleNode</class>
  </compound>
  <compound kind="file">
    <name>tree_runner.hpp</name>
    <path>include/horus_bt/</path>
    <filename>tree__runner_8hpp.html</filename>
    <includes id="node__ptr_8hpp" name="node_ptr.hpp" local="yes" import="no" module="no" objc="no">horus_bt/node_ptr.hpp</includes>
    <class kind="class">horus_bt::TreeRunner</class>
  </compound>
  <compound kind="class">
    <name>horus_bt::AddTrialNoteNode</name>
    <filename>classhorus__bt_1_1AddTrialNoteNode.html</filename>
    <base>ServiceLeaf&lt; horus_msgs::srv::AddTrialNote &gt;</base>
  </compound>
  <compound kind="struct">
    <name>horus_bt::BehaviorChannel</name>
    <filename>structhorus__bt_1_1BehaviorChannel.html</filename>
    <member kind="variable">
      <type>std::mutex</type>
      <name>mutex</name>
      <anchorfile>structhorus__bt_1_1BehaviorChannel.html</anchorfile>
      <anchor>a4828b354a2fa3128d9fc59b58efe60ca</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::CalibrateNode</name>
    <filename>classhorus__bt_1_1CalibrateNode.html</filename>
    <member kind="function">
      <type></type>
      <name>CalibrateNode</name>
      <anchorfile>classhorus__bt_1_1CalibrateNode.html</anchorfile>
      <anchor>aee585a22337c14369a9d1b37d98db06c</anchor>
      <arglist>(const std::string &amp;name, const BT::NodeConfig &amp;config, const NodePtr &amp;node)</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>onStart</name>
      <anchorfile>classhorus__bt_1_1CalibrateNode.html</anchorfile>
      <anchor>a1fb990596d78f8ea361f4ab22e4342a8</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>onRunning</name>
      <anchorfile>classhorus__bt_1_1CalibrateNode.html</anchorfile>
      <anchor>a8dc4af5ca520acfef521f625126ff66c</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>onHalted</name>
      <anchorfile>classhorus__bt_1_1CalibrateNode.html</anchorfile>
      <anchor>acb428aafe825af523b727db171ef379a</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static BT::PortsList</type>
      <name>providedPorts</name>
      <anchorfile>classhorus__bt_1_1CalibrateNode.html</anchorfile>
      <anchor>a859f15d36ed684d042cedf7b225743f9</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::EmergencyStopNode</name>
    <filename>classhorus__bt_1_1EmergencyStopNode.html</filename>
  </compound>
  <compound kind="class">
    <name>horus_bt::ExecuteBehaviorNode</name>
    <filename>classhorus__bt_1_1ExecuteBehaviorNode.html</filename>
  </compound>
  <compound kind="class">
    <name>horus_bt::IsAtPoseNode</name>
    <filename>classhorus__bt_1_1IsAtPoseNode.html</filename>
    <member kind="function">
      <type></type>
      <name>IsAtPoseNode</name>
      <anchorfile>classhorus__bt_1_1IsAtPoseNode.html</anchorfile>
      <anchor>a38330a91fed191b14c9a01fe1fb52c6a</anchor>
      <arglist>(const std::string &amp;name, const BT::NodeConfig &amp;config, const NodePtr &amp;node)</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>tick</name>
      <anchorfile>classhorus__bt_1_1IsAtPoseNode.html</anchorfile>
      <anchor>ae456d5cedd7bfc1b82a9e4b51b2f8382</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static BT::PortsList</type>
      <name>providedPorts</name>
      <anchorfile>classhorus__bt_1_1IsAtPoseNode.html</anchorfile>
      <anchor>a21edd62ff6ceaa0be69f917f6a189a8d</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::IsHealthyNode</name>
    <filename>classhorus__bt_1_1IsHealthyNode.html</filename>
    <member kind="function">
      <type></type>
      <name>IsHealthyNode</name>
      <anchorfile>classhorus__bt_1_1IsHealthyNode.html</anchorfile>
      <anchor>a35a31b3cb7438a1c8ca34d225d587213</anchor>
      <arglist>(const std::string &amp;name, const BT::NodeConfig &amp;config, const NodePtr &amp;node)</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>tick</name>
      <anchorfile>classhorus__bt_1_1IsHealthyNode.html</anchorfile>
      <anchor>aea0e8119156985845e5346c08586c19b</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static BT::PortsList</type>
      <name>providedPorts</name>
      <anchorfile>classhorus__bt_1_1IsHealthyNode.html</anchorfile>
      <anchor>ad0f3ee3dac3e832dc13f1a64afd2b801</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>horus_bt::detail::LeafExecutor</name>
    <filename>structhorus__bt_1_1detail_1_1LeafExecutor.html</filename>
    <member kind="variable">
      <type>rclcpp::CallbackGroup::SharedPtr</type>
      <name>group</name>
      <anchorfile>structhorus__bt_1_1detail_1_1LeafExecutor.html</anchorfile>
      <anchor>a2b965de84b6fcab5f389aabc0f5d4931</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>rclcpp::executors::SingleThreadedExecutor</type>
      <name>exec</name>
      <anchorfile>structhorus__bt_1_1detail_1_1LeafExecutor.html</anchorfile>
      <anchor>aaf4fddb4a28877b4de58137a1ba82d2b</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::ServiceLeaf</name>
    <filename>classhorus__bt_1_1ServiceLeaf.html</filename>
    <templarg>class SrvT</templarg>
    <member kind="function" protection="protected" virtualness="pure">
      <type>virtual bool</type>
      <name>fill</name>
      <anchorfile>classhorus__bt_1_1ServiceLeaf.html</anchorfile>
      <anchor>a84c78dace68d6c86772aa01261a28a39</anchor>
      <arglist>(typename SrvT::Request &amp;req)=0</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::SetSpeedScaleNode</name>
    <filename>classhorus__bt_1_1SetSpeedScaleNode.html</filename>
  </compound>
  <compound kind="class">
    <name>horus_bt::StartRecordingNode</name>
    <filename>classhorus__bt_1_1StartRecordingNode.html</filename>
    <base>ServiceLeaf&lt; horus_msgs::srv::SessionControl &gt;</base>
  </compound>
  <compound kind="class">
    <name>horus_bt::StopRecordingNode</name>
    <filename>classhorus__bt_1_1StopRecordingNode.html</filename>
    <base>ServiceLeaf&lt; horus_msgs::srv::SessionControl &gt;</base>
  </compound>
  <compound kind="class">
    <name>horus_bt::TreeRunner</name>
    <filename>classhorus__bt_1_1TreeRunner.html</filename>
    <member kind="typedef">
      <type>std::function&lt; void(std::uint64_t, bool, const std::string &amp;)&gt;</type>
      <name>Done</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>af1f2f578b886c92313240e106d15fb72</anchor>
      <arglist></arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>TreeRunner</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>af4804aa73998077208001c84dd81b1dd</anchor>
      <arglist>(const NodePtr &amp;node, double tick_hz)</arglist>
    </member>
    <member kind="function">
      <type>std::size_t</type>
      <name>load</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>a36bd7d7b7376689de840cea9d4fb18b0</anchor>
      <arglist>(const std::vector&lt; std::string &gt; &amp;dirs)</arglist>
    </member>
    <member kind="function">
      <type>std::vector&lt; std::string &gt;</type>
      <name>trees</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>ae64e606c4c36e21c53209d32b2ae8f3a</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>start</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>a94eb979585b4c25a4aa24c0b2ae0704e</anchor>
      <arglist>(const std::string &amp;tree, std::uint64_t id, Done done)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>stop</name>
      <anchorfile>classhorus__bt_1_1TreeRunner.html</anchorfile>
      <anchor>a1f8e166f025d7a29f41d7d18a7eda0fd</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>horus_bt::WaitForMessageNode</name>
    <filename>classhorus__bt_1_1WaitForMessageNode.html</filename>
    <member kind="function">
      <type></type>
      <name>WaitForMessageNode</name>
      <anchorfile>classhorus__bt_1_1WaitForMessageNode.html</anchorfile>
      <anchor>af4b99fd20e8127742c236b3fb216aba3</anchor>
      <arglist>(const std::string &amp;name, const BT::NodeConfig &amp;config, const NodePtr &amp;node)</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>onStart</name>
      <anchorfile>classhorus__bt_1_1WaitForMessageNode.html</anchorfile>
      <anchor>a572155f83daa58ae5342867537918b0c</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>BT::NodeStatus</type>
      <name>onRunning</name>
      <anchorfile>classhorus__bt_1_1WaitForMessageNode.html</anchorfile>
      <anchor>a50588593d4854c38bbad089571db41dc</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>onHalted</name>
      <anchorfile>classhorus__bt_1_1WaitForMessageNode.html</anchorfile>
      <anchor>aa1f9bdeb2e900584371c82cbc93ebd56</anchor>
      <arglist>() override</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static BT::PortsList</type>
      <name>providedPorts</name>
      <anchorfile>classhorus__bt_1_1WaitForMessageNode.html</anchorfile>
      <anchor>a818a501c0bc6d3d0340a84f63d312bcf</anchor>
      <arglist>()</arglist>
    </member>
  </compound>
</tagfile>
