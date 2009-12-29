<#import "/spring.ftl" as spring />
<div id="job-executions">

	<#if jobInfo??>
		<#assign job_info> for Job = ${jobInfo.name}<#if jobInfo.jobInstanceId??>, instanceId = ${jobInfo.jobInstanceId}<#else>, all instances</#if></#assign>
	</#if>

	<h2>Recent and Current Job Executions${job_info!}</h2>

	<#assign executions_url><@spring.url relativeUrl="${servletPath}/jobs/executions"/></#assign>
	<form action="${executions_url}" method="POST">
		<#if stoppedCount??>
			<p>Stopped ${stoppedCount} Job executions.  <#if stoppedCount gt 0>You may need to wait 
			for them to respond to the signal.</#if></p>
		</#if>
		<input type="hidden" name="_method" value="DELETE"/>	
		<input id="stop" type="submit" value="Stop&nbsp;All" name="stop" />
	</form>

	<#if jobExecutions?? && jobExecutions?size!=0>
		<p/>
		<table title="Recent and Current Job Executions"
			class="bordered-table">
			<tr>
				<th>ID</th>
				<th>Instance</th>
				<th>Name</th>
				<th>Date</th>
				<th>Start</th>
				<th>Duration</th>
				<th>Status</th>
				<th>ExitCode</th>
				<th>Steps</th>
			</tr>
			<#list jobExecutions as execution>
				<#if execution_index % 2 == 0>
					<#assign rowClass="name-sublevel1-even" />
				<#else>
					<#assign rowClass="name-sublevel1-odd" />
				</#if>
				<tr class="${rowClass}">
					<#assign execution_url><@spring.url relativeUrl="${servletPath}/jobs/executions/${execution.id?c}"/></#assign>
					<td><a href="${execution_url}">${execution.id}</a></td>
					<td>${execution.jobId}</td>
					<td>${execution.name}</td>
					<td>${execution.startDate}</td>
					<td>${execution.startTime}</td>
					<td>${execution.duration}</td>
					<td>${execution.jobExecution.status}</td>
					<td>${execution.jobExecution.exitStatus.exitCode}</td>
					<td><#if execution.jobExecution.stepExecutions?size!=0>[<#list execution.jobExecution.stepExecutions as stepExecution><#if stepExecution_index != 0>,</#if>
					<#assign step_url><@spring.url relativeUrl="${servletPath}/jobs/executions/${execution.id?c}/steps/${stepExecution.id?c}/progress"/></#assign>
					<a href="${step_url}"/>${stepExecution.stepName}</a></#list>]</#if></td>
				</tr>
			</#list>
		</table>
		<#if startJobExecution??>
			<ul class="controlLinks">
				<#assign executions_url><@spring.url relativeUrl="${servletPath}/jobs/executions"/></#assign>
				<li>Rows: ${startJobExecution}-${endJobExecution} of ${totalJobExecutions}</li> 
				<#if nextJobExecution??><li><a href="${executions_url}?startJobExecution=${nextJobExecution}&pageSize=${pageSize!20}">Next</a></li></#if>
				<#if previousJobExecution??><li><a href="${executions_url}?startJobExecution=${previousJobExecution}&pageSize=${pageSize!20}">Previous</a></li></#if>
				<!-- TODO: enable pageSize editing -->
				<li>Page Size: ${pageSize!20}</li>
			</ul>
		</#if>

	<#else>
		<p>There are no job executions to display ${job_info!}.</p>
	</#if>
	
</div><!-- job-executions -->
