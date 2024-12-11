#s(hash-table test equal data
	      (("uvm_component" :file "../files/common/uvm_component.svh" :line 49)
	       (:type "class" :desc "virtual class uvm_component extends uvm_report_object;" :col 27 :parent nil)
	       ("get_full_name" :file "../files/common/uvm_component.svh" :line 93)
	       (:type "function" :desc "  extern virtual function string get_full_name ();" :col 33 :parent "uvm_component")
	       ("get_next_child" :file "../files/common/uvm_component.svh" :line 116)
	       (:type "function" :desc "  extern function int get_next_child (ref string name);" :col 22 :parent "uvm_component")
	       ("get_first_child" :file "../files/common/uvm_component.svh" :line 133)
	       (:type "function" :desc "  extern function int get_first_child (ref string name);" :col 22 :parent "uvm_component")
	       ("get_num_children" :file "../files/common/uvm_component.svh" :line 141)
	       (:type "function" :desc "  extern function int get_num_children ();" :col 22 :parent "uvm_component")
	       ("has_child" :file "../files/common/uvm_component.svh" :line 149)
	       (:type "function" :desc "  extern function int has_child (string name);" :col 22 :parent "uvm_component")
	       ("get_depth" :file "../files/common/uvm_component.svh" :line 178)
	       (:type "function" :desc "  extern function int unsigned get_depth();" :col 31 :parent "uvm_component")
	       ("massage_scope" :file "../files/common/uvm_component.svh" :line 688)
	       (:type "function" :desc "  extern function string massage_scope(string scope);" :col 25 :parent "uvm_component")
	       ("use_automatic_config" :file "../files/common/uvm_component.svh" :line 740)
	       (:type "function" :desc "  extern virtual function bit use_automatic_config();" :col 30 :parent "uvm_component")
	       ("print_config_matches" :file "../files/common/uvm_component.svh" :line 770)
	       (:type "bit" :desc "  static `ifndef UVM_ENABLE_DEPRECATED_API local `endif bit print_config_matches;" :col 60 :parent "print_config_with_audit")
	       ("get_print_config_matches" :file "../files/common/uvm_component.svh" :line 782)
	       (:type "function" :desc "  static function bit get_print_config_matches() ;" :col 22 :parent "uvm_component")
	       ("begin_tr" :file "../files/common/uvm_component.svh" :line 1220)
	       (:type "function" :desc "   extern function int begin_tr (uvm_transaction tr," :col 23 :parent "uvm_component")
	       ("record_error_tr" :file "../files/common/uvm_component.svh" :line 1296)
	       (:type "function" :desc "  extern function int record_error_tr (string stream_name=\"main\"," :col 22 :parent "uvm_component")
	       ("record_event_tr" :file "../files/common/uvm_component.svh" :line 1317)
	       (:type "function" :desc "  extern function int record_event_tr (string stream_name=\"main\"," :col 22 :parent "uvm_component")
	       ("print_enabled" :file "../files/common/uvm_component.svh" :line 1341)
	       (:type "bit" :desc "  bit print_enabled = 1;" :col 6 :parent "free_tr_stream")
	       ("m_build_done" :file "../files/common/uvm_component.svh" :line 1383)
	       (:type "bit" :desc "  /*protected*/ bit  m_build_done;" :col 21 :parent "set_tr_database")
	       ("m_phasing_active" :file "../files/common/uvm_component.svh" :line 1384)
	       (:type "int" :desc "  /*protected*/ int  m_phasing_active;" :col 21 :parent "set_tr_database")
	       ("m_add_child" :file "../files/common/uvm_component.svh" :line 1391)
	       (:type "function" :desc "  extern protected virtual function bit  m_add_child(uvm_component child);" :col 41 :parent "uvm_component")
	       ("m_begin_tr" :file "../files/common/uvm_component.svh" :line 1409)
	       (:type "function" :desc "  extern protected function int m_begin_tr (uvm_transaction tr," :col 32 :parent "uvm_component")
	       ("m_name" :file "../files/common/uvm_component.svh" :line 1414)
	       (:type "string" :desc "  string m_name;" :col 9 :parent "m_begin_tr")
	       ("recording_detail" :file "../files/common/uvm_component.svh" :line 1421)
	       (:type "int unsigned" :desc "  int unsigned recording_detail = UVM_NONE;" :col 15 :parent "m_begin_tr")
	       ("get_recording_enabled" :file "../files/common/uvm_component.svh" :line 1424)
	       (:type "function" :desc "  extern virtual function bit get_recording_enabled();" :col 30 :parent "uvm_component")
	       ("new" :file "../files/common/uvm_component.svh" :line 66)
	       (:type "function" :desc "  extern function new (string name, uvm_component parent);" :col 18 :parent "uvm_component")
	       ("get_parent" :file "../files/common/uvm_component.svh" :line 83)
	       (:type "function" :desc "  extern virtual function uvm_component get_parent ();" :col 40 :parent "uvm_component")
	       ("get_children" :file "../files/common/uvm_component.svh" :line 107)
	       (:type "function" :desc "  extern function void get_children(ref uvm_component children[$]);" :col 23 :parent "uvm_component")
	       ("get_child" :file "../files/common/uvm_component.svh" :line 112)
	       (:type "function" :desc "  extern function uvm_component get_child (string name);" :col 32 :parent "uvm_component")
	       ("set_name" :file "../files/common/uvm_component.svh" :line 157)
	       (:type "function" :desc "  extern virtual function void set_name (string name);" :col 31 :parent "uvm_component")
	       ("lookup" :file "../files/common/uvm_component.svh" :line 169)
	       (:type "function" :desc "  extern function uvm_component lookup (string name);" :col 32 :parent "uvm_component")
	       ("build_phase" :file "../files/common/uvm_component.svh" :line 211)
	       (:type "function" :desc "  extern virtual function void build_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("connect_phase" :file "../files/common/uvm_component.svh" :line 220)
	       (:type "function" :desc "  extern virtual function void connect_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("end_of_elaboration_phase" :file "../files/common/uvm_component.svh" :line 229)
	       (:type "function" :desc "  extern virtual function void end_of_elaboration_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("start_of_simulation_phase" :file "../files/common/uvm_component.svh" :line 238)
	       (:type "function" :desc "  extern virtual function void start_of_simulation_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("run_phase" :file "../files/common/uvm_component.svh" :line 256)
	       (:type "task" :desc "  extern virtual task run_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("pre_reset_phase" :file "../files/common/uvm_component.svh" :line 277)
	       (:type "task" :desc "  extern virtual task pre_reset_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("reset_phase" :file "../files/common/uvm_component.svh" :line 298)
	       (:type "task" :desc "  extern virtual task reset_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("post_reset_phase" :file "../files/common/uvm_component.svh" :line 319)
	       (:type "task" :desc "  extern virtual task post_reset_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("pre_configure_phase" :file "../files/common/uvm_component.svh" :line 340)
	       (:type "task" :desc "  extern virtual task pre_configure_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("configure_phase" :file "../files/common/uvm_component.svh" :line 361)
	       (:type "task" :desc "  extern virtual task configure_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("post_configure_phase" :file "../files/common/uvm_component.svh" :line 382)
	       (:type "task" :desc "  extern virtual task post_configure_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("pre_main_phase" :file "../files/common/uvm_component.svh" :line 403)
	       (:type "task" :desc "  extern virtual task pre_main_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("main_phase" :file "../files/common/uvm_component.svh" :line 424)
	       (:type "task" :desc "  extern virtual task main_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("post_main_phase" :file "../files/common/uvm_component.svh" :line 445)
	       (:type "task" :desc "  extern virtual task post_main_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("pre_shutdown_phase" :file "../files/common/uvm_component.svh" :line 466)
	       (:type "task" :desc "  extern virtual task pre_shutdown_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("shutdown_phase" :file "../files/common/uvm_component.svh" :line 487)
	       (:type "task" :desc "  extern virtual task shutdown_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("post_shutdown_phase" :file "../files/common/uvm_component.svh" :line 508)
	       (:type "task" :desc "  extern virtual task post_shutdown_phase(uvm_phase phase);" :col 22 :parent "uvm_component")
	       ("extract_phase" :file "../files/common/uvm_component.svh" :line 517)
	       (:type "function" :desc "  extern virtual function void extract_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("check_phase" :file "../files/common/uvm_component.svh" :line 528)
	       (:type "function" :desc "  extern virtual function void check_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("report_phase" :file "../files/common/uvm_component.svh" :line 537)
	       (:type "function" :desc "  extern virtual function void report_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("final_phase" :file "../files/common/uvm_component.svh" :line 546)
	       (:type "function" :desc "  extern virtual function void final_phase(uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("phase_started" :file "../files/common/uvm_component.svh" :line 555)
	       (:type "function" :desc "  extern virtual function void phase_started (uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("phase_ready_to_end" :file "../files/common/uvm_component.svh" :line 580)
	       (:type "function" :desc "  extern virtual function void phase_ready_to_end (uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("phase_ended" :file "../files/common/uvm_component.svh" :line 590)
	       (:type "function" :desc "  extern virtual function void phase_ended (uvm_phase phase);" :col 31 :parent "uvm_component")
	       ("set_domain" :file "../files/common/uvm_component.svh" :line 608)
	       (:type "function" :desc "  extern function void set_domain(uvm_domain domain, int hier=1);" :col 23 :parent "uvm_component")
	       ("get_domain" :file "../files/common/uvm_component.svh" :line 616)
	       (:type "function" :desc "  extern function uvm_domain get_domain();" :col 29 :parent "uvm_component")
	       ("define_domain" :file "../files/common/uvm_component.svh" :line 650)
	       (:type "function" :desc "  extern virtual protected function void define_domain(uvm_domain domain);" :col 41 :parent "uvm_component")
	       ("suspend" :file "../files/common/uvm_component.svh" :line 661)
	       (:type "task" :desc "  extern virtual task suspend ();" :col 22 :parent "uvm_component")
	       ("resume" :file "../files/common/uvm_component.svh" :line 674)
	       (:type "task" :desc "  extern virtual task resume ();" :col 22 :parent "uvm_component")
	       ("resolve_bindings" :file "../files/common/uvm_component.svh" :line 686)
	       (:type "function" :desc "  extern virtual function void resolve_bindings ();" :col 31 :parent "uvm_component")
	       ("apply_config_settings" :file "../files/common/uvm_component.svh" :line 732)
	       (:type "function" :desc "  extern virtual function void apply_config_settings (bit verbose = 0);" :col 31 :parent "uvm_component")
	       ("print_config" :file "../files/common/uvm_component.svh" :line 757)
	       (:type "function" :desc "  extern function void print_config(bit recurse = 0, bit audit = 0);" :col 23 :parent "uvm_component")
	       ("print_config_with_audit" :file "../files/common/uvm_component.svh" :line 768)
	       (:type "function" :desc "  extern function void print_config_with_audit(bit recurse = 0);" :col 23 :parent "uvm_component")
	       ("set_print_config_matches" :file "../files/common/uvm_component.svh" :line 794)
	       (:type "function" :desc "   static function void set_print_config_matches(bit val) ;" :col 24 :parent "uvm_component")
	       ("raised" :file "../files/common/uvm_component.svh" :line 818)
	       (:type "function" :desc "  virtual function void raised (uvm_objection objection, uvm_object source_obj," :col 24 :parent "uvm_component")
	       ("dropped" :file "../files/common/uvm_component.svh" :line 833)
	       (:type "function" :desc "  virtual function void dropped (uvm_objection objection, uvm_object source_obj," :col 24 :parent "uvm_component")
	       ("all_dropped" :file "../files/common/uvm_component.svh" :line 848)
	       (:type "task" :desc "  virtual task all_dropped (uvm_objection objection, uvm_object source_obj," :col 15 :parent "uvm_component")
	       ("create_component" :file "../files/common/uvm_component.svh" :line 881)
	       (:type "function" :desc "  extern function uvm_component create_component (string requested_type_name," :col 32 :parent "uvm_component")
	       ("create_object" :file "../files/common/uvm_component.svh" :line 900)
	       (:type "function" :desc "  extern function uvm_object create_object (string requested_type_name," :col 29 :parent "uvm_component")
	       ("set_type_override_by_type" :file "../files/common/uvm_component.svh" :line 923)
	       (:type "function" :desc "  extern static function void set_type_override_by_type" :col 30 :parent "uvm_component")
	       ("set_inst_override_by_type" :file "../files/common/uvm_component.svh" :line 980)
	       (:type "function" :desc "  extern function void set_inst_override_by_type(string relative_inst_path," :col 23 :parent "uvm_component")
	       ("set_type_override" :file "../files/common/uvm_component.svh" :line 1001)
	       (:type "function" :desc "  extern static function void set_type_override(string original_type_name," :col 30 :parent "uvm_component")
	       ("set_inst_override" :file "../files/common/uvm_component.svh" :line 1025)
	       (:type "function" :desc "  extern function void set_inst_override(string relative_inst_path," :col 23 :parent "uvm_component")
	       ("print_override_info" :file "../files/common/uvm_component.svh" :line 1037)
	       (:type "function" :desc "  extern function void print_override_info(string requested_type_name," :col 23 :parent "uvm_component")
	       ("set_report_id_verbosity_hier" :file "../files/common/uvm_component.svh" :line 1055)
	       (:type "function" :desc "  extern function void set_report_id_verbosity_hier (string id," :col 23 :parent "uvm_component")
	       ("set_report_severity_id_verbosity_hier" :file "../files/common/uvm_component.svh" :line 1069)
	       (:type "function" :desc "  extern function void set_report_severity_id_verbosity_hier(uvm_severity severity," :col 23 :parent "uvm_component")
	       ("set_report_severity_action_hier" :file "../files/common/uvm_component.svh" :line 1076)
	       (:type "function" :desc "  extern function void set_report_severity_action_hier (uvm_severity severity," :col 23 :parent "uvm_component")
	       ("set_report_id_action_hier" :file "../files/common/uvm_component.svh" :line 1082)
	       (:type "function" :desc "  extern function void set_report_id_action_hier (string id," :col 23 :parent "uvm_component")
	       ("set_report_severity_id_action_hier" :file "../files/common/uvm_component.svh" :line 1096)
	       (:type "function" :desc "  extern function void set_report_severity_id_action_hier(uvm_severity severity," :col 23 :parent "uvm_component")
	       ("set_report_default_file_hier" :file "../files/common/uvm_component.svh" :line 1104)
	       (:type "function" :desc "  extern function void set_report_default_file_hier (UVM_FILE file);" :col 23 :parent "uvm_component")
	       ("set_report_severity_file_hier" :file "../files/common/uvm_component.svh" :line 1108)
	       (:type "function" :desc "  extern function void set_report_severity_file_hier (uvm_severity severity," :col 23 :parent "uvm_component")
	       ("set_report_id_file_hier" :file "../files/common/uvm_component.svh" :line 1113)
	       (:type "function" :desc "  extern function void set_report_id_file_hier (string id," :col 23 :parent "uvm_component")
	       ("set_report_severity_id_file_hier" :file "../files/common/uvm_component.svh" :line 1127)
	       (:type "function" :desc "  extern function void set_report_severity_id_file_hier(uvm_severity severity," :col 23 :parent "uvm_component")
	       ("set_report_verbosity_level_hier" :file "../files/common/uvm_component.svh" :line 1141)
	       (:type "function" :desc "    extern function void set_report_verbosity_level_hier (int verbosity);" :col 25 :parent "uvm_component")
	       ("pre_abort" :file "../files/common/uvm_component.svh" :line 1162)
	       (:type "function" :desc "  virtual function void pre_abort;" :col 24 :parent "uvm_component")
	       ("accept_tr" :file "../files/common/uvm_component.svh" :line 1191)
	       (:type "function" :desc "  extern function void accept_tr (uvm_transaction tr, time accept_time = 0);" :col 23 :parent "uvm_component")
	       ("error_str" :file "../files/common/uvm_component.svh" :line 1481)
	       (:type "string" :desc "  string error_str;" :col 9 :parent "m_unsupported_set_local")
	       ("cs" :file "../files/common/uvm_component.svh" :line 1483)
	       (:type "uvm_coreservice_t" :desc "  uvm_coreservice_t cs;" :col 20 :parent "m_unsupported_set_local")
	       ("do_accept_tr" :file "../files/common/uvm_component.svh" :line 1201)
	       (:type "function" :desc "  extern virtual protected function void do_accept_tr (uvm_transaction tr);" :col 41 :parent "uvm_component")
	       ("do_begin_tr" :file "../files/common/uvm_component.svh" :line 1235)
	       (:type "function" :desc "    function void do_begin_tr (uvm_transaction tr," :col 18 :parent "uvm_component")
	       ("end_tr" :file "../files/common/uvm_component.svh" :line 1265)
	       (:type "function" :desc "  extern function void end_tr (uvm_transaction tr," :col 23 :parent "uvm_component")
	       ("do_end_tr" :file "../files/common/uvm_component.svh" :line 1277)
	       (:type "function" :desc "  extern virtual protected function void do_end_tr (uvm_transaction tr," :col 41 :parent "uvm_component")
	       ("get_tr_stream" :file "../files/common/uvm_component.svh" :line 1326)
	       (:type "function" :desc "  extern virtual function uvm_tr_stream get_tr_stream(string name," :col 40 :parent "uvm_component")
	       ("free_tr_stream" :file "../files/common/uvm_component.svh" :line 1331)
	       (:type "function" :desc "  extern virtual function void free_tr_stream(uvm_tr_stream stream);" :col 31 :parent "uvm_component")
	       ("do_execute_op" :file "../files/common/uvm_component.svh" :line 1344)
	       (:type "function" :desc "  extern virtual function void do_execute_op( uvm_field_op op );" :col 31 :parent "uvm_component")
	       ("get_tr_database" :file "../files/common/uvm_component.svh" :line 1354)
	       (:type "function" :desc "  extern virtual function uvm_tr_database get_tr_database();" :col 42 :parent "uvm_component")
	       ("set_tr_database" :file "../files/common/uvm_component.svh" :line 1357)
	       (:type "function" :desc "  extern virtual function void set_tr_database(uvm_tr_database db);" :col 31 :parent "uvm_component")
	       ("set_local" :file "../files/common/uvm_component.svh" :line 1386)
	       (:type "function" :desc "  extern                   function void set_local(uvm_resource_base rsrc) ;" :col 41 :parent "uvm_component")
	       ("m_set_full_name" :file "../files/common/uvm_component.svh" :line 1392)
	       (:type "function" :desc "  extern local     virtual function void m_set_full_name();" :col 41 :parent "uvm_component")
	       ("do_resolve_bindings" :file "../files/common/uvm_component.svh" :line 1394)
	       (:type "function" :desc "  extern                   function void do_resolve_bindings();" :col 41 :parent "uvm_component")
	       ("do_flush" :file "../files/common/uvm_component.svh" :line 1395)
	       (:type "function" :desc "  extern                   function void do_flush();" :col 41 :parent "uvm_component")
	       ("flush" :file "../files/common/uvm_component.svh" :line 1397)
	       (:type "function" :desc "  extern virtual           function void flush ();" :col 41 :parent "uvm_component")
	       ("m_extract_name" :file "../files/common/uvm_component.svh" :line 1399)
	       (:type "function" :desc "  extern local             function void m_extract_name(string name ," :col 41 :parent "uvm_component")
	       ("create" :file "../files/common/uvm_component.svh" :line 1404)
	       (:type "function" :desc "  extern virtual function uvm_object create (string name=\"\");" :col 37 :parent "uvm_component")
	       ("clone" :file "../files/common/uvm_component.svh" :line 1405)
	       (:type "function" :desc "  extern virtual function uvm_object clone  ();" :col 37 :parent "uvm_component")
	       ("set_recording_enabled" :file "../files/common/uvm_component.svh" :line 1437)
	       (:type "function" :desc "  extern virtual function void set_recording_enabled(bit enabled);" :col 31 :parent "uvm_component")
	       ("set_recording_enabled_hier" :file "../files/common/uvm_component.svh" :line 1440)
	       (:type "function" :desc "  extern virtual function void set_recording_enabled_hier (bit enabled);" :col 31 :parent "uvm_component")
	       ("do_print" :file "../files/common/uvm_component.svh" :line 1442)
	       (:type "function" :desc "  extern         function void   do_print(uvm_printer printer);" :col 33 :parent "uvm_component")
	       ("m_set_cl_msg_args" :file "../files/common/uvm_component.svh" :line 1445)
	       (:type "function" :desc "  extern function void m_set_cl_msg_args;" :col 23 :parent "uvm_component")
	       ("m_set_cl_verb" :file "../files/common/uvm_component.svh" :line 1446)
	       (:type "function" :desc "  extern function void m_set_cl_verb;" :col 23 :parent "uvm_component")
	       ("m_set_cl_action" :file "../files/common/uvm_component.svh" :line 1447)
	       (:type "function" :desc "  extern function void m_set_cl_action;" :col 23 :parent "uvm_component")
	       ("m_set_cl_sev" :file "../files/common/uvm_component.svh" :line 1448)
	       (:type "function" :desc "  extern function void m_set_cl_sev;" :col 23 :parent "uvm_component")
	       ("m_apply_verbosity_settings" :file "../files/common/uvm_component.svh" :line 1449)
	       (:type "function" :desc "  extern function void m_apply_verbosity_settings(uvm_phase phase);" :col 23 :parent "uvm_component")
	       ("m_do_pre_abort" :file "../files/common/uvm_component.svh" :line 1455)
	       (:type "function" :desc "  extern /*local*/ function void m_do_pre_abort;" :col 33 :parent "uvm_component")
	       ("m_unsupported_set_local" :file "../files/common/uvm_component.svh" :line 1459)
	       (:type "function" :desc "  extern function void m_unsupported_set_local(uvm_resource_base rsrc);" :col 23 :parent "uvm_component")))