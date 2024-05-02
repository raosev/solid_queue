# frozen_string_literal: true

module SolidQueue
  class Execution
    module Dispatching
      extend ActiveSupport::Concern

      class_methods do
        def dispatch_jobs(job_ids)
          jobs = Job.where(id: job_ids)

          Job.dispatch_all(jobs).map(&:id).tap do |dispatched_job_ids|
            where(id: where(job_id: dispatched_job_ids).pluck(:id)).delete_all
            SolidQueue.logger.info("[SolidQueue] Dispatched #{dispatched_job_ids.size} jobs")
          end
        end
      end
    end
  end
end
