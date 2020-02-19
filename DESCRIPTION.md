<p>The whole process, from loading *.SET data to produce the crossvalidation tables, is performed executing first script and then a function.</p>
<p>The script is named <em>processing_&lt;feature_type&gt;_&lt;classifer_type&gt;</em>, where <em>&lt;feature_type&gt;</em> refers to the used features (<em>spectral</em> or <em>temporal</em>) and <em>&lt;classifier_type&gt;</em> refers to the used classifier (<em>static</em> or <em>dynamic</em>). It performs the following operations:</p>
<ol>
<li>Load a set of *.SET file, the cleaned EEG file (in the EEGLab proprietary format) that contains also the stimuli information (onset positions and onset labels);</li>
<li>For each *.SET file:
<ol style="list-style-type: lower-alpha;">
<li>Extract the desiderd epochs according to the onset positions and re-code them in a more friendly way, accordingly to the <em>&lt;task&gt;</em> (<em>Active</em>,<em> Passive</em>,<em> Predictive</em>), the <em>&lt;type&gt;</em> (<em>Image</em>,<em> Sound</em>) and the arousal level (<em>High</em>,<em> Low</em>);</li>
<li>For each epoch extract the <em>&lt;feature_type&gt;</em> features and concatenate them in a table:
<ol style="list-style-type: lower-roman;">
<li><em>processing_&lt;feature_type&gt;_static</em> extract one feature vector for each epoch;</li>
<li><em>processing_&lt;feature_type&gt;_dynamic</em> extract N feature vector for each epoch by using a 500ms-long sliding window.</li>
</ol>
</li>
</ol>
</li>
</ol>
<p>As output for <em>processing_&lt;feature_type&gt;_static</em> a data struct (named&nbsp;<em>table</em>) containing the feature matrix (field<em> table</em>), the class vector (field <em>class</em>) the subject code (field <em>var_name</em>) and the feature name (field <em>feat_name</em>).</p>
<p>The output for&nbsp; <em>processing_&lt;feature_type&gt;_dynamic</em> is similar to the static one, eccept that table <em>class</em> and <em>var_name</em> are a 3D arrays (the 3<sup>rd</sup> dimention is the &ldquo;time&rdquo; dimension, N long).</p>
<p>Thee function is named <em>crossval_&lt;classifier_type&gt;</em> and takes as inputs the <em>table</em> struct (output of the script)&nbsp; and the number of repetitions of the 10 fold crossvalidation scheme <em>n_rep</em>. The input struct must be choosen coherently wiith the used function. For example, if table was obtained using <em>processing_&lt;feature_type&gt;_static</em>, function <em>processing_static</em> must be used.</p>
<p>The function <em>crossval_static</em> performs the following operations:</p>
<ol>
<li>Create the OVO (one-versus-one) combinations of <em>&lt;tasks&gt;</em> and <em>&lt;type&gt;</em>;</li>
<li>For each combination:
<ol style="list-style-type: lower-alpha;">
<li>Perform for <em>n_rep</em> a 10-fold crossvaidations scheme. Morte in depth, within each crossvalidation iteration (over a total of 10&times;<em>n_rep</em>):
<ol style="list-style-type: lower-roman;">
<li>Perform a feature selection;</li>
<li>Train the classifiers (LDA, SVM, kNN, ZeroR and Random);</li>
<li>Evaluate the classification accuracy;</li>
</ol>
</li>
<li>Plot the scalp distribution of the biserial correlation coefficients using the whole (unsplitted) data.</li>
</ol>
</li>
</ol>
<p>As output, one matrix for each OVO combination (named <em>Table_&lt;task&gt;_&lt;type&gt;</em>) is produced. It is a <em>n_rep</em>&times;5 array and contains the ordered accuracies (one for each repetition) related to abovementioned 5 classifiers.&nbsp;</p>
<p>The function<em> crossval_dynamic</em> performs the same operations (eccept for the 2b) of the static one, for each one of the &nbsp;&ldquo;time points&rdquo; (3<sup>rd</sup> dimension of table) indipentently. As output, one <em>n_rep</em>&times;5&times;N matrix for each OVO combination (named <em>Table_&lt;task&gt;_&lt;type&gt;</em>) is produced.</p>
