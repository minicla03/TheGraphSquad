// Machines
CREATE (m1:Machine {processor_id: 'M1', name: 'AssemblyMachine1', load: 3})
CREATE (m2:Machine {processor_id: 'M2', name: 'AssemblyMachine2', load: 2})
CREATE (m3:Machine {processor_id: 'M3', name: 'AssemblyMachine3', load: 1})

// Production Processes
CREATE (prod1:Process {process_id: 'Prod1', name: 'WidgetProduction_Q1'})
CREATE (prod2:Process {process_id: 'Prod2', name: 'GadgetProduction_Q1'})
CREATE (prod3:Process {process_id: 'Prod3', name: 'ComponentProduction_Q1'})

// Shared Task (part of WidgetProduction_Q1 and GadgetProduction_Q1)
CREATE (t0:Job {job_id: 'T0', name: 'Shared_MaterialPrep', status: 'Completed', duration: 5, quality_score: 0.2, completion_progress: 1.0})
CREATE (t0)-[:RUNS_ON]->(m1)

// Tasks for WidgetProduction_Q1 (Diamond-shaped DAG)
CREATE (t1:Job {job_id: 'T1', name: 'Widget_Assembly1', status: 'Completed', duration: 15, quality_score: 0.7, completion_progress: 1.0})
CREATE (t2:Job {job_id: 'T2', name: 'Widget_Assembly2', status: 'Completed', duration: 12, quality_score: 0.6, completion_progress: 1.0})
CREATE (t3:Job {job_id: 'T3', name: 'Widget_QualityCheck', status: 'Completed', duration: 6, quality_score: 0.4, completion_progress: 1.0})
CREATE (t4:Job {job_id: 'T4', name: 'Widget_Packaging', status: 'Running', duration: 3, quality_score: 0.2, completion_progress: 0.5})
CREATE (t1)-[:RUNS_ON]->(m1), (t2)-[:RUNS_ON]->(m1), (t3)-[:RUNS_ON]->(m2), (t4)-[:RUNS_ON]->(m3)
CREATE (t1)-[:DEPENDS_ON]->(t0), (t2)-[:DEPENDS_ON]->(t0), (t3)-[:DEPENDS_ON]->(t1), (t3)-[:DEPENDS_ON]->(t2), (t4)-[:DEPENDS_ON]->(t3)
CREATE (t4)-[:IS_INSTANCE_OF]->(prod1)

// Tasks for GadgetProduction_Q1 (Parallel Paths DAG)
CREATE (t5:Job {job_id: 'T5', name: 'Gadget_Assembly1', status: 'Completed', duration: 14, quality_score: 0.6, completion_progress: 1.0})
CREATE (t6:Job {job_id: 'T6', name: 'Gadget_Assembly2', status: 'Completed', duration: 11, quality_score: 0.5, completion_progress: 1.0})
CREATE (t7:Job {job_id: 'T7', name: 'Gadget_QualityCheck1', status: 'Completed', duration: 5, quality_score: 0.3, completion_progress: 1.0})
CREATE (t8:Job {job_id: 'T8', name: 'Gadget_QualityCheck2', status: 'Completed', duration: 4, quality_score: 0.2, completion_progress: 1.0})
CREATE (t9:Job {job_id: 'T9', name: 'Gadget_Packaging', status: 'Pending', duration: 2, quality_score: 0.1, completion_progress: 0.0})
CREATE (t5)-[:RUNS_ON]->(m1), (t6)-[:RUNS_ON]->(m1), (t7)-[:RUNS_ON]->(m2), (t8)-[:RUNS_ON]->(m2), (t9)-[:RUNS_ON]->(m3)
CREATE (t5)-[:DEPENDS_ON]->(t0), (t6)-[:DEPENDS_ON]->(t0), (t7)-[:DEPENDS_ON]->(t5), (t8)-[:DEPENDS_ON]->(t6), (t9)-[:DEPENDS_ON]->(t7), (t9)-[:DEPENDS_ON]->(t8)
CREATE (t9)-[:IS_INSTANCE_OF]->(prod2)

// Shared Task (part of GadgetProduction_Q1 and ComponentProduction_Q1)
CREATE (t10:Job {job_id: 'T10', name: 'Shared_ComponentAssembly', status: 'Running', duration: 10, quality_score: 0.5, completion_progress: 0.5})
CREATE (t10)-[:RUNS_ON]->(m2)

// Tasks for ComponentProduction_Q1 (Single Chain DAG)
CREATE (t11:Job {job_id: 'T11', name: 'Component_MaterialPrep', status: 'Completed', duration: 12, quality_score: 0.5, completion_progress: 1.0})
CREATE (t12:Job {job_id: 'T12', name: 'Component_QualityCheck', status: 'Pending', duration: 5, quality_score: 0.3, completion_progress: 0.0})
CREATE (t13:Job {job_id: 'T13', name: 'Component_Inspection', status: 'Pending', duration: 6, quality_score: 0.4, completion_progress: 0.0})
CREATE (t14:Job {job_id: 'T14', name: 'Component_Packaging', status: 'Pending', duration: 4, quality_score: 0.2, completion_progress: 0.0})
CREATE (t11)-[:RUNS_ON]->(m1), (t12)-[:RUNS_ON]->(m2), (t13)-[:RUNS_ON]->(m3), (t14)-[:RUNS_ON]->(m3)
CREATE (t12)-[:DEPENDS_ON]->(t10), (t10)-[:DEPENDS_ON]->(t11), (t13)-[:DEPENDS_ON]->(t12), (t14)-[:DEPENDS_ON]->(t13)
CREATE (t14)-[:IS_INSTANCE_OF]->(prod3)

// Queue for AssemblyMachine1 (t0 -> t1 -> t5 -> t2 -> t6 -> t11)
CREATE (m1)-[:QUEUE_HEAD]->(t0)
CREATE (m1)-[:QUEUE_TAIL]->(t11)
CREATE (t1)-[:WAITS]->(t0), (t5)-[:WAITS]->(t1), (t2)-[:WAITS]->(t5), (t6)-[:WAITS]->(t2), (t11)-[:WAITS]->(t6)

// Queue for AssemblyMachine2 (t3 -> t7 -> t8 -> t10 -> t12)
CREATE (m2)-[:QUEUE_HEAD]->(t3)
CREATE (m2)-[:QUEUE_TAIL]->(t12)
CREATE (t7)-[:WAITS]->(t3), (t8)-[:WAITS]->(t7), (t10)-[:WAITS]->(t8), (t12)-[:WAITS]->(t10)

// Queue for AssemblyMachine3 (t4 -> t9 -> t13 -> t14)
CREATE (m3)-[:QUEUE_HEAD]->(t4)
CREATE (m3)-[:QUEUE_TAIL]->(t14)
CREATE (t9)-[:WAITS]->(t4), (t13)-[:WAITS]->(t9), (t14)-[:WAITS]->(t13);