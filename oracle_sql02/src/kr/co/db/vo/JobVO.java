package kr.co.db.vo;

import java.util.Objects;

public class JobVO {

	private String jobId;
	private String jobTittle;
	private int minSalary;
	private int maxSalary;
	public String getJobId() {
		return jobId;
	}
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}
	public String getJobTittle() {
		return jobTittle;
	}
	public void setJobTittle(String jobTittle) {
		this.jobTittle = jobTittle;
	}
	public int getMinSalary() {
		return minSalary;
	}
	public void setMinSalary(int minSalary) {
		this.minSalary = minSalary;
	}
	public int getMaxSalary() {
		return maxSalary;
	}
	public void setMaxSalary(int maxSalary) {
		this.maxSalary = maxSalary;
	}
	@Override
	public int hashCode() {
		return Objects.hash(jobId, jobTittle, maxSalary, minSalary);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		JobVO other = (JobVO) obj;
		return Objects.equals(jobId, other.jobId) && Objects.equals(jobTittle, other.jobTittle)
				&& maxSalary == other.maxSalary && minSalary == other.minSalary;
	}
	@Override
	public String toString() {
		return "JobVO [jobId=" + jobId + ", jobTittle=" + jobTittle + ", minSalary=" + minSalary + ", maxSalary="
				+ maxSalary + "]";
	}
	
	
	
}
