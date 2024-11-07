
/****** Object:  User [User1]    Script Date: 9/22/2021 5:44:11 PM ******/
CREATE USER [User1] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [User2]    Script Date: 9/22/2021 5:44:11 PM ******/
CREATE USER [User2] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [User3]    Script Date: 9/22/2021 5:44:11 PM ******/
CREATE USER [User3] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [dcnserver]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [dcnserver]
GO
/****** Object:  Schema [jobs]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [jobs]
GO
/****** Object:  Schema [jobs_internal]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [jobs_internal]
GO
/****** Object:  Schema [Security]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [Security]
GO
/****** Object:  Schema [UserData]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [UserData]
GO
/****** Object:  Schema [UserData2]    Script Date: 9/22/2021 5:44:12 PM ******/
CREATE SCHEMA [UserData2]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_diagramobjects]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE FUNCTION [dbo].[fn_diagramobjects]() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END
	
GO
/****** Object:  UserDefinedFunction [jobs_internal].[fn_has_credential_perms]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [jobs_internal].[fn_has_credential_perms](@credential_name NVARCHAR(128))
RETURNS BIT
AS
BEGIN
    RETURN HAS_PERMS_BY_NAME(quotename(@credential_name), 'DATABASE SCOPED CREDENTIAL', 'REFERENCES')
END
GO
/****** Object:  Table [UserData2].[Variable]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserData2].[Variable](
	[VariableID] [nvarchar](50) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[Values] [nvarchar](50) NOT NULL,
	[Unrestricted] [smallint] NOT NULL,
 CONSTRAINT [PK_Variable_1] PRIMARY KEY CLUSTERED 
(
	[VariableID] ASC,
	[UserID] ASC,
	[Values] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[sp_getVariablesId]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[sp_getVariablesId](@UserId varchar(50),@Unrestricted smallint)
RETURNS TABLE
AS
RETURN
(
	SELECT Unrestricted,VariableID  FROM UserData2.Variable
	WHERE UserId=@UserId
	AND Unrestricted=@Unrestricted
)

GO
/****** Object:  UserDefinedFunction [dbo].[sp_getAllVariablesId]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[sp_getAllVariablesId](@Unrestricted smallint)
RETURNS TABLE
AS
 
RETURN
(
SELECT * FROM UserData2.Variable
	WHERE Unrestricted=@Unrestricted
	
);
GO
/****** Object:  UserDefinedFunction [dbo].[sp_getAllUserId]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[sp_getAllUserId]()
RETURNS TABLE
AS
 
RETURN
(
SELECT distinct  UserId FROM UserData2.Variable
	
	
);
GO
/****** Object:  UserDefinedFunction [Security].[fn_securitypredicate2]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Security].[fn_securitypredicate2](@UserId varchar(50))  
    RETURNS TABLE  
    WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate2_result  
    WHERE  
        DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID('AppUser')
        AND CAST(SESSION_CONTEXT(N'UserId') AS varchar) = @UserId;
GO
/****** Object:  UserDefinedFunction [Security].[tvf_securitypredicate]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Security].[tvf_securitypredicate](@User AS nvarchar(50))  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS tvf_securitypredicate_result
WHERE @User = USER_NAME() OR USER_NAME() = 'CLOPEZ';  
GO
/****** Object:  Table [dbo].[Disk_Check]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disk_Check](
	[DB Name] [nvarchar](128) NULL,
	[DB File Name] [sysname] NOT NULL,
	[File ID] [smallint] NOT NULL,
	[DB File Type] [varchar](4) NOT NULL,
	[Disk Location] [nvarchar](2) NULL,
	[Avg Read Stall] [int] NULL,
	[Read Performance] [varchar](22) NULL,
	[Num Reads] [bigint] NOT NULL,
	[Avg_Write_Stall] [int] NULL,
	[Write Performance] [varchar](22) NULL,
	[Num Writes] [bigint] NOT NULL,
	[Size on Disk GB] [decimal](10, 2) NULL,
	[dateRec] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Table_A]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_A](
	[Variable_1] [nchar](10) NULL,
	[Variable_2] [nvarchar](50) NULL,
	[Variable_3] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_ConsumingQueriesStats]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ConsumingQueriesStats](
	[DatabaseName] [nvarchar](128) NULL,
	[ObjectName] [nvarchar](257) NULL,
	[DiskReads] [bigint] NULL,
	[MemoryReads] [bigint] NULL,
	[Total_IO_Reads] [bigint] NULL,
	[Executions] [bigint] NULL,
	[IO_Per_Execution] [bigint] NULL,
	[CPUTime] [bigint] NULL,
	[DiskWaitAndCPUTime] [bigint] NULL,
	[MemoryWrites] [bigint] NULL,
	[DateLastExecuted] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tests_A]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tests_A](
	[Variable_ID] [nvarchar](50) NOT NULL,
	[restrictedValue] [nvarchar](50) NULL,
	[fk_Tests_A_vId] [nvarchar](50) NULL,
 CONSTRAINT [PK_TestsA] PRIMARY KEY CLUSTERED 
(
	[Variable_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tests_B]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tests_B](
	[Variable_ID] [nvarchar](50) NOT NULL,
	[restrictedValue] [nvarchar](50) NULL,
	[fk_Value_vId] [nvarchar](50) NULL,
 CONSTRAINT [PK_Tests_B] PRIMARY KEY CLUSTERED 
(
	[Variable_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestsValue_B]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestsValue_B](
	[Variable_ID] [nvarchar](50) NOT NULL,
	[restrictedValue] [nvarchar](50) NULL,
 CONSTRAINT [PK_TestsValue_B] PRIMARY KEY CLUSTERED 
(
	[Variable_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dcnserver].[tbl_range]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dcnserver].[tbl_range](
	[date_UTC] [date] NOT NULL,
	[configurationID] [uniqueidentifier] NOT NULL,
	[current_index] [bigint] NOT NULL,
 CONSTRAINT [PK_type] PRIMARY KEY CLUSTERED 
(
	[date_UTC] ASC,
	[configurationID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dcnserver].[tbl_unused_range]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dcnserver].[tbl_unused_range](
	[configurationID] [uniqueidentifier] NOT NULL,
	[date_utc] [date] NOT NULL,
	[start_range] [bigint] NOT NULL,
	[end_range] [bigint] NOT NULL,
 CONSTRAINT [PK_unsed_range] PRIMARY KEY CLUSTERED 
(
	[configurationID] ASC,
	[date_utc] ASC,
	[start_range] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[__MigrationHistory]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_jobs_internal.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[command_data]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[command_data](
	[command_data_id] [uniqueidentifier] NOT NULL,
	[script_has_been_split] [bit] NOT NULL,
	[text] [nvarchar](max) NOT NULL,
	[text_checksum]  AS (binary_checksum([text])) PERSISTED,
 CONSTRAINT [PK_jobs_internal.command_data] PRIMARY KEY CLUSTERED 
(
	[command_data_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[job_cancellations]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[job_cancellations](
	[job_execution_id] [uniqueidentifier] NOT NULL,
	[requested_time] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_jobs_internal.job_cancellations] PRIMARY KEY CLUSTERED 
(
	[job_execution_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[job_executions]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[job_executions](
	[job_execution_id] [uniqueidentifier] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[job_version_number] [int] NOT NULL,
	[step_id] [int] NULL,
	[create_time] [datetime2](7) NOT NULL,
	[start_time] [datetime2](7) NULL,
	[end_time] [datetime2](7) NULL,
	[row_version] [timestamp] NOT NULL,
	[infrastructure_failures] [int] NOT NULL,
	[current_task_attempts] [int] NOT NULL,
	[next_retry_delay_ms] [int] NOT NULL,
	[do_not_retry_until_time] [datetime2](7) NULL,
	[lifecycle] [nvarchar](50) NOT NULL,
	[is_active] [bit] NOT NULL,
	[target_id] [uniqueidentifier] NULL,
	[parent_job_execution_id] [uniqueidentifier] NULL,
	[root_job_execution_id] [uniqueidentifier] NOT NULL,
	[initiated_for_schedule_time] [datetime2](7) NULL,
	[last_job_task_execution_id] [uniqueidentifier] NULL,
 CONSTRAINT [PK_jobs_internal.job_executions] PRIMARY KEY CLUSTERED 
(
	[job_execution_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[job_task_executions]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[job_task_executions](
	[job_task_execution_id] [uniqueidentifier] NOT NULL,
	[job_execution_id] [uniqueidentifier] NOT NULL,
	[previous_job_task_execution_id] [uniqueidentifier] NULL,
	[task_type] [nvarchar](50) NOT NULL,
	[lifecycle] [nvarchar](50) NOT NULL,
	[is_active] [bit] NOT NULL,
	[create_time] [datetime2](7) NOT NULL,
	[start_time] [datetime2](7) NULL,
	[end_time] [datetime2](7) NULL,
	[message] [nvarchar](max) NULL,
	[exception] [nvarchar](max) NULL,
	[row_version] [timestamp] NOT NULL,
 CONSTRAINT [PK_jobs_internal.job_task_executions] PRIMARY KEY CLUSTERED 
(
	[job_task_execution_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[job_versions]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[job_versions](
	[job_id] [uniqueidentifier] NOT NULL,
	[job_version_number] [int] NOT NULL,
 CONSTRAINT [PK_jobs_internal.job_versions] PRIMARY KEY CLUSTERED 
(
	[job_id] ASC,
	[job_version_number] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[jobs]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[jobs](
	[job_id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[delete_requested_time] [datetime2](7) NULL,
	[is_system] [bit] NOT NULL,
	[schedule_start_time] [datetime2](7) NOT NULL,
	[schedule_end_time] [datetime2](7) NOT NULL,
	[schedule_interval_type] [nvarchar](50) NOT NULL,
	[schedule_interval_count] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[description] [nvarchar](512) NOT NULL,
	[last_job_execution_id] [uniqueidentifier] NULL,
 CONSTRAINT [PK_jobs_internal.jobs] PRIMARY KEY CLUSTERED 
(
	[job_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[jobstep_data]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[jobstep_data](
	[jobstep_data_id] [uniqueidentifier] NOT NULL,
	[command_type] [nvarchar](50) NOT NULL,
	[result_set_destination_target_id] [uniqueidentifier] NULL,
	[result_set_destination_credential_name] [nvarchar](128) NULL,
	[result_set_destination_schema_name] [nvarchar](128) NULL,
	[result_set_destination_table_name] [nvarchar](128) NULL,
	[command_data_id] [uniqueidentifier] NULL,
	[credential_name] [nvarchar](128) NULL,
	[target_id] [uniqueidentifier] NULL,
	[initial_retry_interval_ms] [int] NOT NULL,
	[maximum_retry_interval_ms] [int] NOT NULL,
	[retry_interval_backoff_multiplier] [real] NOT NULL,
	[retry_attempts] [int] NOT NULL,
	[step_timeout_ms] [int] NOT NULL,
	[max_parallelism] [int] NULL,
 CONSTRAINT [PK_jobs_internal.jobstep_data] PRIMARY KEY CLUSTERED 
(
	[jobstep_data_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[jobsteps]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[jobsteps](
	[job_id] [uniqueidentifier] NOT NULL,
	[job_version_number] [int] NOT NULL,
	[step_id] [int] NOT NULL,
	[jobstep_data_id] [uniqueidentifier] NOT NULL,
	[step_name] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_jobs_internal.jobsteps] PRIMARY KEY CLUSTERED 
(
	[job_id] ASC,
	[job_version_number] ASC,
	[step_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[script_batches]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[script_batches](
	[command_data_id] [uniqueidentifier] NOT NULL,
	[script_batch_number] [int] NOT NULL,
	[command_text] [nvarchar](max) NULL,
 CONSTRAINT [PK_jobs_internal.script_batches] PRIMARY KEY CLUSTERED 
(
	[command_data_id] ASC,
	[script_batch_number] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[target_associations]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[target_associations](
	[parent_target_id] [uniqueidentifier] NOT NULL,
	[child_target_id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_jobs_internal.target_associations] PRIMARY KEY CLUSTERED 
(
	[parent_target_id] ASC,
	[child_target_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[target_group_memberships]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[target_group_memberships](
	[parent_target_id] [uniqueidentifier] NOT NULL,
	[child_target_id] [uniqueidentifier] NOT NULL,
	[include] [bit] NOT NULL,
 CONSTRAINT [PK_jobs_internal.target_group_memberships] PRIMARY KEY CLUSTERED 
(
	[parent_target_id] ASC,
	[child_target_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [jobs_internal].[targets]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jobs_internal].[targets](
	[target_id] [uniqueidentifier] NOT NULL,
	[row_version] [timestamp] NOT NULL,
	[last_completed_refresh_start_time] [datetime2](7) NULL,
	[target_group_name] [nvarchar](128) NULL,
	[delete_requested_time] [datetime2](7) NULL,
	[subscription_id] [uniqueidentifier] NULL,
	[resource_group_name] [nvarchar](128) NULL,
	[server_name] [nvarchar](256) NULL,
	[database_name] [nvarchar](128) NULL,
	[refresh_credential_name] [nvarchar](128) NULL,
	[elastic_pool_name] [nvarchar](128) NULL,
	[shard_map_name] [nvarchar](128) NULL,
	[target_type] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_jobs_internal.targets] PRIMARY KEY CLUSTERED 
(
	[target_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserData].[User]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserData].[User](
	[ID] [nvarchar](50) NOT NULL,
	[Restrict] [int] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserData].[Variable]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserData].[Variable](
	[VariableID] [nvarchar](50) NOT NULL,
	[UserID] [nvarchar](50) NOT NULL,
	[Values] [nvarchar](50) NOT NULL,
	[Unrestricted] [smallint] NULL,
 CONSTRAINT [PK_Variable] PRIMARY KEY CLUSTERED 
(
	[VariableID] ASC,
	[UserID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserData2].[User]    Script Date: 9/22/2021 5:44:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserData2].[User](
	[ID] [nvarchar](50) NOT NULL,
	[Restrict] [int] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 11, N'OK', 141, 17, N'OK', 152, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-06-30T01:21:02.520' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 8, N'Very Good', 30, 5, N'Very Good', 219, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-06-29T01:21:02.520' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 5, N'Very Good', 89, 2, N'Very Good', 3, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-14T01:21:02.520' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 4, N'Very Good', 12, 3, N'Very Good', 7, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-14T01:21:02.520' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 6, N'Very Good', 88, 3, N'Very Good', 3, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-14T21:18:49.160' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 3, N'Very Good', 12, 3, N'Very Good', 8, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-14T21:18:49.160' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 11, N'OK', 124, 15, N'OK', 78, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-14T22:25:55.797' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 15, N'OK', 18, 8, N'Very Good', 100, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-14T22:25:55.797' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 11, N'OK', 124, 15, N'OK', 78, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-14T22:26:42.297' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 15, N'OK', 18, 8, N'Very Good', 103, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-14T22:26:42.297' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 11, N'OK', 124, 15, N'OK', 78, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-14T22:27:42.183' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 15, N'OK', 18, 8, N'Very Good', 104, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-14T22:27:42.183' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 12, N'OK', 97, 10, N'OK', 40, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-15T17:58:28.777' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 7, N'Very Good', 16, 4, N'Very Good', 48, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-15T17:58:28.777' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 10, N'OK', 110, 65, N'Serious I/O Bottleneck', 71, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-16T17:25:48.797' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 8, N'Very Good', 20, 5, N'Very Good', 94, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-16T17:25:48.797' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 10, N'OK', 113, 65, N'Serious I/O Bottleneck', 71, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-16T17:26:01.267' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 8, N'Very Good', 20, 5, N'Very Good', 97, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-16T17:26:01.267' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 26, N'Slow, Needs Attention', 128, 54, N'Serious I/O Bottleneck', 113, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-19T18:29:43.653' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 9, N'Very Good', 24, 9, N'Very Good', 136, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-19T18:29:43.653' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 9, N'Very Good', 81, 6, N'Very Good', 10, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-20T21:46:18.330' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 4, N'Very Good', 14, 4, N'Very Good', 50, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-20T21:46:18.330' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 9, N'Very Good', 83, 6, N'Very Good', 13, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-20T21:50:26.540' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 4, N'Very Good', 16, 4, N'Very Good', 57, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-20T21:50:26.540' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 6, N'Very Good', 61, 4, N'Very Good', 7, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-21T12:22:24.650' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 4, N'Very Good', 14, 3, N'Very Good', 14, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-21T12:22:24.650' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'data_0', 1, N'Data', N'59', 7, N'Very Good', 106, 8, N'Very Good', 71, CAST(0.03 AS Decimal(10, 2)), CAST(N'2021-07-22T18:14:05.643' AS DateTime))
INSERT [dbo].[Disk_Check] ([DB Name], [DB File Name], [File ID], [DB File Type], [Disk Location], [Avg Read Stall], [Read Performance], [Num Reads], [Avg_Write_Stall], [Write Performance], [Num Writes], [Size on Disk GB], [dateRec]) VALUES (N'CP_TestingDB', N'log', 2, N'Log', N'59', 4, N'Very Good', 21, 4, N'Very Good', 133, CAST(0.02 AS Decimal(10, 2)), CAST(N'2021-07-22T18:14:05.643' AS DateTime))
GO
INSERT [dbo].[tbl_ConsumingQueriesStats] ([DatabaseName], [ObjectName], [DiskReads], [MemoryReads], [Total_IO_Reads], [Executions], [IO_Per_Execution], [CPUTime], [DiskWaitAndCPUTime], [MemoryWrites], [DateLastExecuted]) VALUES (NULL, NULL, 2528, 128728, 131256, 1569, 123914, 827853, 1490127, 310, CAST(N'2021-06-24T23:21:16.750' AS DateTime))
GO
INSERT [dbo].[Tests_A] ([Variable_ID], [restrictedValue], [fk_Tests_A_vId]) VALUES (N'965b4b9f-0503a7c9-9cf6354b', N'36502', N'c5296d36-9cf6354b-2e236be4')
INSERT [dbo].[Tests_A] ([Variable_ID], [restrictedValue], [fk_Tests_A_vId]) VALUES (N'c5296d36-9cf6354b-2e236be4', N'36501', NULL)
INSERT [dbo].[Tests_A] ([Variable_ID], [restrictedValue], [fk_Tests_A_vId]) VALUES (N'd9ac8848-18e03417-a951a0aa', N'36503', N'c5296d36-9cf6354b-2e236be4')
INSERT [dbo].[Tests_A] ([Variable_ID], [restrictedValue], [fk_Tests_A_vId]) VALUES (N'e603a25c-20201e0b-31497d1e', N'36502', NULL)
GO
INSERT [dcnserver].[tbl_range] ([date_UTC], [configurationID], [current_index]) VALUES (CAST(N'2021-08-13' AS Date), N'42e6eb63-ba05-47c2-ad0b-307e4bfc28db', 1051)
GO
INSERT [dcnserver].[tbl_unused_range] ([configurationID], [date_utc], [start_range], [end_range]) VALUES (N'42e6eb63-ba05-47c2-ad0b-307e4bfc28db', CAST(N'2021-08-13' AS Date), 792, 800)
GO
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201605030549080_V4.0.0_InitialCreate', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5D5F73DB38927FBFAAFB0E2A3DED6ECD5AB667676E2665EF56E238B3CEC649CA72A6EE4D455390CD0D456A48CA63DFD57DB27BB88F745FE100FE13FEA30182A494F353621168341A3FA01B4077E37FFFFB7FCEFEF6B48E278F28CBA334399F9E1C1D4F272809D36594DC9F4FB7C5EACF3F4DFFF6D77FFD97B3CBE5FA69F26B53EE7B520ED74CF2F3E943516C5ECD6679F880D6417EB48EC22CCDD3557114A6EB59B04C67A7C7C73FCF4E4E66089398625A93C9D9CD3629A2352AFFC07F5EA4498836C53688AFD3258AF3FA77FC655E529D7C0CD628DF04213A9F5EB7F45FFFC7364347F3DFE2B74111DC05393A7A9FDEE547979874F15C129A4E5EC75180799CA378359D0449921641817BF0EA4B8EE6459626F7F30DFE21886F9F3708975B05718EEA9EBDDA158776F2F8947472B6ABD8900AB77991AE2D099E7C5F4B6DC6577792FDB4952A966B2524D2EB52B6E7D38B748D1B5812514E277C7BAF2EE28C94B593FE1145F3BB894DCDEF5AA41D1FFD74747C74FCDDE4621B17B8DA7982B64516E0129FB7777114FE033DDFA65F5172FEE3CFE1F7A77F39413FAE8EFFF2E34F6140F716F71797637EC03F7DCED20DCA8AE71BB4126570B59C4E662C89194FA3A520AF5E09EC976D84FFFF711BC7C15D8C5A84CDB494E661166D8ABF07F91B8492F9268E8A86DC9B348D51905853BC454F2D0D0C7C3CBBA793EBE0E9034AEE8B073CACC1D374F22E7A42CBE6979AEA9724C28B01AE54645B646EF563F018DD9790E1DAC7233C2FD0A682D70D8ACB32F943B4A9E6E611F57DC140F15D96AE6FD29825411759DC06D93D229D4BF5E5E6E9360B2D58AE06E14D50E0C9954B9966A8B3A5776C2B0BB50C358CAB4B365DA4593F9BEDE6B0766633A2F734B3299A0731B3297E5D663657BDC3CCAEC7985068A6A17252FE70EC654E721CDCA01C0B7C8E8AB7282FA2A44441852FBE6BF6742E32B44409D1A7A48CA66B27A73F81FAA667E14B92072B2463A4321B0C4C40173D57266EC9A80CC28346F3182A0E3B602E38BB4A22C2DF0D2AB2E7ABA440D923B612F38602FEE5FB53EB39803B16ADB76BAF3419626F82F06BBA5A5D634C44587DA3AC152D166CEC326931F1D74581D69BA2239F6421BBC5B677BA2DACBBACD4958CCAF6ABDE792D6932032C2D12B966AF3F2E18DD29F04A7F5699214C195B1344BD561BA5ACAB2A17BABA86760C34D56C8704D8357D37002C6BD8B3B5AA7C5B5487624D895694AA64CDE1C7EDFA8E2C83804A440E8E565A47EB4C64B7EB4ABB63C88D4607CB53B7F299163DC562A79A55E537C705D8A4336CD6600D7BC2EA61C1668D091597F5E7A6959CE392FF2CD314421999A6B0599B7CAE4B87BB260DB16678329C2D5B7D8B6254E05DC76F5BAC75D19218740D13786450F5B7C1B0CEE7CFB8EEBAEBD112D96B2DB731DECF06592167C491E265A2E89823BDC63A1F71F7CDB372916E93A29B8AB84C48E165D761C4E65B79E6542E746AA99C9CF67E5058AF1F4ACB7CC19461D65AFA934C1B30DF6D35C187202F70FDCB27146E0B8D3E680B2CEA1A1C93C2779946100B755509AD16F3A7196A9287AB209C8CD603B0445D6C3FE8B49280553AED7C6DC46DCD2BC9B4579A60AE73895A03FCCDA696E8A1CCA7966147CB8BA9DF6DB2ECFFC6CF7810DB5A375DAD1DB51D6632249CECC89BF4F756B5D426489404D9F37442AEF5B7598692B044EAF9B4341C187B42611C0B5DA6E6D7BC4833F40B4A5086195C7E0E0A6C4925E511E4665B20C079F22AC31A35DB86648ABC0BA218FFD3F14CF5A2EC65711BE45FFD1CD27E444F4579E68BEDFCE0B9EBD1F4DBF4635A91FB82978DD865903F442B143E87F15876F355FE3A2CA247D4D5CA75B981F81C90C1D5AD57A609926A6BDB8AA2BC10C1487F9766CD760234A4EAD3FB87285ED21C2A75F1CE2A95D55158B96251998ED6967738B4B9089210C57100B3D4850A8ABE70E5F41DE10B3B9E9081B8AF0AAAB92ECFC14CDC96851CB8240B1F0033BB926A3ECB024646AB52FE8FF29846DAB26A6E1BC3D2C46F53CE71CBE96FA7A96594DF8E5A724906C5B839660A2DC42D35C3BFBEB06C2762A861BB371197FEBE5746ED51806625055F2972CAC8DC1FB186A2377C413DD884D27E6F0B45BA0AAED5F7854299AEBB4656C3F8DB38D2745FF68EB69E15DA23F42E072D1673CCD5FCD0AE162A5BC515BEDCFAEE0FBF0CE1430130C3B42388051ADD8E307C91FA9CA1C728DDE6260E4D5BADFCEB88372DDFCA8EF5804F86AE519E07F7FDBB3F5E3E91E891487B71E5A7A57D3FEBF2A78E801B35930262B773BE6FDA7C6E2624062070FB01DE4C28965558EFD4B535BD545532F75659B39311DC54F6643B54E486B71826AFEF725C322CEA55C3C182D81D44DADA0DF2234C5BB3F75017B2720B5C89E0972CDD6EAE11B9AF2113477E00252DBAA0A8D0F3C7585858EFCC351CAF4341AED4204F585D7C948647CB39CD89C0F314E7A81FC41EA13A3B52CD7369150A372E2B03DF6297382596934ED71561BC5DDA9BC19015608819CF6B4AF81A6177C848D1B5E896A4AEA97342156017C57A1E4C819A67FF8BC50846C11B4CB9DE7F9001C3D33A43F903C1782DA86FC48F140E6437E5EC05D33045AD9E0B1D30FD3ACFD330F27BCA2B507E51817BAC029D75173586B532A16A50A3CFECCCC195844901AFE97671A6E9A9B03A327351D555782DA1AF16553BAD01824CBDAD0102E5F1751C44B1CDB777AD67B97588793912E5CAEC493F1A4E4851F688324353A73FFCD88B2AAE076E204300B246B1D370F8F58A374CED57BA2E91B6363B71AFE1B6BA1D3B204AD769D912AD555FCB9640796F962DFD319EE44C9A1C57117B7959F7097EA1025294C6E9D6BBD2E4279C83BE7542DFE513390F24591EFA42A1B285F1D128E9B40D300F49BFD65DF59E7644ABEC6C4CB7CB184FF328FC9CA6B17FEB4D203E3EF6D4136F6FED244A8AFB869E4A2CFE8143D37DC18CDF217B08B2E575B0E961D018CA873B6C7537AE8324B847D998339F6365E00D938299FD5A83766903FD417947F3200E1DB5593CA535A81EBA46FCFACEFDC930D32934AD4E38E827FFA7AF7C601D3367F21B64738E4DC86CA2B633E25D3C93B68C95C265B29C007398ED5663E670A1C9131762AECEA77F12E46C6EA195C8AE05660CD8168E8F8E4E8446F07C405965955FE0C1C2F3334A0A71F24449186D8218C60F57DD69BECEDA36F92F6FD1062564230113BF1766DA36B905C224BDB319052F23EA8498770D1ED401F00CDA5A771F160A220EF4C425407BDF449F9960EC8A30550F2103FA5E9EF64155D694ADCC0A8C2AE18DC1F730B8657248686025CFD3C240CA12A8F214159019E00FA7B25E75186B3BB0C904D0A9F16110A38D9BD38C372CBC98197FCA6516A00EE1ADC9D1A66CCD1FDE203200424013C9620B4488AC205CC9C3EEC7C7291FAB05828D2A160B8819303C9501624C3B6CAC598FB6A1510063C253212B3F2C8D80CAD20883A284CD07E0BA7219E8C38DC5FE50473332BCE1253F6F9026B8ED04647A38F7BE97C3CC0D43709006C8D0482106D55C508EAD85014D75E06AD174919D32F408DC1F731C125C968655C8328CA9EB20BAAE51766C02A7A92126D97685B11B43904DA7892CDE0B1D5A853D42951C97ACC6BF2DC705597699245E9429D3E1916D374636076BB43587125044081987FC9B6E7CB222C773442F80E378D9F7133FDD507DBBA77E621A2A10D4849C54FE4F6B8404CBDA23C6AE5693266712885B750225CF935C997BC95985759FEC2A9EC6D432AA0181F024CBFA38CA0435C743AA3063111CC9FBD60AE1C070A4C2032C251EBDBDE014CC1104179A6828384AC12303E1481B72351048E181042AD8384415ECE02309DA811BED0EF1573C709990C15E2C796BF10C86656BF11D0AA62DBCF555D07271DDD73A96C351ED126A373CACED053418AEED0508BF151B19D972F523C66DDBA9784D6282DECD0B4D00B9B4ED412D0D257323DB1BCA013B18201B371CAA1D94DAFEF5B241B335747BBA3E1BC9BAD548BA2B0FC360AA7D465133D8E29B8A0E1E75728AB0D38E135E98679F922A1DC88464AE4C497AAE200F83A5E8F73BC3EDFAC11ACF738743327B47515AFC9D1A1E1655ADDF30000BE2D398BE50263E7C0C726EF6EB772C63043892F4B3AA7EA0C4CBDA0B23C341CB14C76EC004F80D69AF3EF090287A8B6D7E3F8EF166268754AD1683053AE75452D90B405B80B757A08E6AD129B81805750767CFA9639554E36E0E478285E9E88E6700C151D4BA478705F6720E63EC32E8D0CE5B2490513A5ED8F10EBE2A2E0DD729700D94B57C24459612524519C527C4757EC9511DDA994B13465464F1122D8BCEDBC5C2C90029E08FA5C42C8C0225E62B8C52AE260321A1A80EA9BA7BFA5446A1F57A3013A2E217A4A4A8D3013331DA4159418F75E6369364FC86143439DF2203D16A4EC948356B118880983252414F38FD039167D3E328483327D606B25CE0AA40915975395A543BD2D9C4849B4EA8D292DC53CAC854A531228B4D6D7BC7CD6A61D98307A35224758BCA8C15064C50E2ABC05221E90329F9DE28432959E1EC960ABD7094C193A2AC055A6E5261DF70964A441DA2C7B32F0DD26359378A401A960793A69B04B4F1647289C043D0D407B69A2034B6B734377AD18162CEA0C4BB0A53D0330649F2E5813D7DAF0893EA2E439EB25C809CBAF52EC3CA8E31CB4E0CE5D1F68C09E6F1222B267CA7B7E5CAF47E8B545036711D7C1F81911D6C877983492F46602047BF1317FA740C40C0B0E00FBD148CE11FFE046E0CF8B069CAC38CAFDF51324F7949E4817686B2B1075E263D1B6D30B0A0DA1D965954529F796DCF78AF792FE2E2FDE487316BDA977E0D7292BA62ABFBC33B63779710EF7B6DB01CBBCA457CA6D62020BD8FB6BA5F4A2FEDEE2253FA65F7A82DCCEEC112415AFA14333D867B1553BD569D1068240BF72316DAF121578BD4D8A27C1DDD6199FEDB3BC49AE5E0D88052D0AC1C3ACBDC263FB22874577F4D46280E1E9B96627770CCEC5BEE507F40F04A62702504CC73B533611FAB8ADA7DB097B545AA230CEACEB82E4B4A7B546D432CB9CDBE556D1EC91DB3542E2E9AB35163CF0567AC5ECC1FC12548DF6DB9E7908A75C177A88318046F21D871B3BB548CAF32E8CFD4A17E305D3C613A9EB8035C5FFA9C65CC68EA85692538BF421A42209A64A6A25C80DE0496FE04B09B164B07028A28D72DB0C89A54ABED9576FBED6C36C7B4D641FDC3D98CBC3B8B36C53688CBE4C179F3E13AD86CA2E43EDFD5AC7F99CC3741483AF2E7F974F2B48E93FC7CFA50149B57B3595E92CE8FD66DB6E2305DCF82653A3B3D3EFE797672325B573466212377FE02BE6DA948B3E01E715F890C97E85D94E54563074F2717CBB5A4187381AFB8556C1A13EFE8C5416C6E1A9B3AE4FF553DABD4CE9A4676727E87BBBE26AE15E51BBE0AA409B571FD7918C441A64F947C91C6DB75527D0AAB4F8B2581A4F87A858E6A85CFBF07F91B8492F9268E0A9674F540C6E221C81777B8C422AF8AC01BA8F227D3242B5F0C49A4FE8C939BE036220C1F379B784480F0A2D7EE9EF0A2690480176D6D95E0A94A3C5EFE89D923E685035E9AACD8580C4D366C19120BFCDD86ACDE17926E212B4B2E72AC9B96BBB28BA25257769D91B5CABFB002683B6CAB2C92407CC248C7C197240F5648C647B5C88379A8166E8FEDDF926D32B8F98294B66EBD9F254D37821D864A0E4727DC5D251161E10615D9F315566DD923D6DD394B38AACA2C32526811D5A5166BC9C641DDD075F014ADB76B6D43EBAA4CB7869816DE04E1D774B56ADC2549821516424C437755E9C59A2A6ED9F0EBA240EB4D91CBDA09DA6F164A112F8EE431B2745BF0D22AD7CDA2FAA690D1B87A4C660EFB5562EE0ACC4A79499496E5347B2FE4F9E1E93DD6175189323DA30E223C872536AC59ECA0A4C7435ABF287343D8C0E812958BAD46913E214E135C9605F0CA5C9728171E2B4593CF9F71C535A75AF2455EFF6CB3517840CB6D8CA8971BD97D42F5799193EFD68C36D4F12E5B431B25F622682837CA4965B9B68DB48AC9D686E55BBA48B789B09BE21B09AB42F0562E13626A71E845CD8F36E06BDF3EE441477DD8A73547E37BE96FE9517848C0562065E5BD5773E38DAAD663D4DFB82A9D156023ABA9AE19162685193F28A8BDE1B11EEEFDC04CCFA611DEC6B56F02735B38FCBBBD1E50E82D27752555532EDAE926FDBD75DF62F62EE9EFCD08D86D2C57599017D936248FC5BD0BA218FF236C2CE9328B555BC86268B659756B9B7F956FBDC2AAC0A2C0259C76601FD153516EEDB08D143CF39BB0047FADF7AB4BF2DD72B3FA36FD9856D4BFE0491E4BECAE7491A44D0B5B52C67A603F442B143E87B1D4D6889B8F76B61C492EF188045B2EA87F1EE52843FED6084D765396587459F2641921D9D992766BA03A90C116F6BB346BCC38111651536AB14AB3456BCBA9A0319E4E659DF1FB54ABBA50059866D553185AB96A3663E65DD87803CEF918F739E25A5776D8901B4868C65C487DCF8F7BA9703A5856BD804A97BB9F5929EB728BCE3D21CDA836BA2561DBBDED5EABB3FF1796E235CAF3E09E23B46E7EB460E889380B080627DAFDDCBBF53AD23AD9F8ADD8AC8E5739F9FFA7D51FAC96C9AAA53F3AAC8EAA240B035872230DA64FF5A4717BDD6FD993888F8B74BD21C7BDCBDA4D59B10CC5B8E8226CCAE23D4A59D8F1D8553CC3AED9BF2F5D71473DD0BE4893654456A4C9AF41BC458C03B19467954EDB27848A79B40E0AA7F3ED5D7B382C1CF150DFECFD304A77BC726C454C66F5674754CE5186D72F916C5EFE6E0FF27AFC4482CBFA8B8EA4806A0A11878CEA4BB22E45E1E7348D0F11D8632DC00739A16AF9E83DA52AA974F0B7F13C6D29808A3451F571B1C15F6D672F45F890277025EE97B9FB3277479DBBB21956513BE8C9F510644B4CE6657ABD4C2F1FD3AB86D3759004F728F3AC2939EADDEC5D6D0B1296C997C53AD04A5EBA46D424075D253A1D4409C1B3431C8B50B9FF5C1721231DFD55A17C65AA2F099D1628EEC522E604987C72A37A9584F17629DC00D63FEE19960C21F65E7144277A74C59096C661E167A471374540FAB25DA84C9CF683ADADAD1C8E1EE3DC4A56641E4F7598DB1DF9EEE0F2D4444509B16E6D3CD448316F6C7CA9FEDE589246CED335B184B28D8F1D89BD35DC052B33D2891277BA5B2E2D5BE0B56CF9C84B43DF475794BB861E6EB1B5CCEF0CAFABFCE3368ECFA7AB20E6CF2DE1A2E2C39F5D102C49EFE5C14974470C1067201F536582300FC3D88AD837109539C8E04C437D533D02AD1BC684487BBE48BB46D7BFB47FB791F675943B137E5F8A88C46496A2C9EB887B3EECBD2A329D60413C464B12F25E056C1C910204AF17718448804053006FCAA215CA8BDBF42B4ACEA7A7C727A7D3C9EB380AF22A4D421DD0FF8A4F750F8AF03FF99E44F8A3E57AC657B7CF1340A8E4F93296640920135454F65C74FF3F90800AF1A10183417036E3A99C718015085459C8B749F4DB1645E5FE7C554624121492188B1689332D5D45D87C45FD8EFCD79260654054F593C7200BF17EF70FEBE0E98F064AB401A11D09658C396C240CD16AE6911008781A0936229D15E074721D3C7D40C97DF1703EFDE1D89AB639165DD509E1258AAB64899ECEA7FF59527E35B9FAF78589F877934F195E105E4D8E27FF45735E3E63E1C6B87024A511D7C9E94F9E5A6542D70D08EFD00C1DA2EEA115F0CA01186A8E569791ED7908FD40DB0B863501F2156B5162BFCC6A82E1DD890202DE2BE2190A6247EABB200B773E85D87628295B25E3A860E476A4BCA8297C49524D11A304525D5D674445622172AE9A21A0019509821A532F7C9D38F0D54ADA1DAB607301D6499A9685C86D80EF0FF4DD1169296CB926014AB6D4430BA9E7DFA28D44DFC9FC3BBCE5FB5232FC6A728BD5001903B5CE02B1AFF03AACFA83071D91BF4F7BEAD089AC439F33144679B92DFB376BBDB78BDEA7B613BDF07E2AE3DD7A2724490C20885E2510BB26767EF53D35C0E506F0BB9B502607705F25DBBC00EE1B4F261D80AEC3E420C292B6E204A7C3522EA508B7326DD67369B0FF08B6CC80F6499FC688373DABB846808F8CFE3811226C189C1DE4D79795B9A82DB27DB53605FE7C599D5E993A75DAAEEF42D43C2B2D177D0BE1D941CB828E6DE838A37A3F9CFEDEFE525EC4FC8212949108ECCF64BF9B25E501F2665B101567291E651A04776DABC87AE04E509AE7C09D9C32AD81D771A4A241FDDA47546C688773F4FD39C0522646E8C0988266A7B3627972852E27DB328A9D548F3633835F746B6EB77DD8AD02D97E8C5775D685FDB393803ADA1B988CE704166AD9664C346911E0830270BA808C8C05BA1DACC4FD1C7753FA852ECBB2967497D599CAE6E057DBEEB71AD7DBCD40E4B003912F28A2BA43BABDB5BE1DBBDD50EC7A30D926A3F070BB4AA5A3F07123DCE7D602BCC4CB5CA9600BBBD201D9BC9803EC5D5BF538EC3E0D1053E4757E491220F8BD4287DE4674E984101F651E7BA06785181CE5573A4CCC9286F4E90F3F5A0B9E0D57F2EDDBA288EAF2DB8C2450D9B3FCB900AC5EDC478CF68AF996CF72D5D5062DC11661738889CC41511F40625EBFC556BB9F0E184F2F602618DFB52E0E502CAD8E6701758C16D4BAB484923276E90546870B23300694214D5E1C96E57E49E6D8248F8ECEFEDC156D1CA5D9CE75388267E2ADACB70E2A1850739EF5642B1F01543BB14B1F0D6CF8E25F35C41AB0F6080C310BE7D3E3A3A313A1BFD2C71A198ACCEF2CC53F09E430CA5056D92B17782F58644124C6A07DCEF09A1A6D8258D217AEAC23E8676D13FC97B76883F7A724B850ECB5A7B6DB26B82965920D135A62444BED2ED03CE99A2B9142B91670C3DAFECC8E2A00243280F4040E956784627C54AE108ECE102E581A8BCF6170B778AF7A398385090F114B94D941D61FD63A0D9E1D567CC07AA851DF05F295D1EDEFD5EF6C289E1DE70792FA60ABA5DAAA557C1A90AE3F88E8B255DBDF6CD9A286ED3D840370C2FCE1C1A4BF39EC8824038C9886399AEC3700400F134B866CFB6E0C8C8021490C8893C962B1F68CB0EE8C675BC8B791AA27781CD7B3C3E8DA30E83664BBD00094BDF4E740CA7D3C24F09B9E8970F45EE817AD76593EC68096EA2989B120C65497D9775AFADF1CDC4471800C3ECB773F46D1D9A46B9EB70E36D81A0957E3DA7B6EA8DE43F0C86365FA3BF31A53F31DD0E9D7C8B6DCF0506CD23A0D7C02623A5BFB56D62B3B236BDFD629FE95C14195DDCB21999DCD047CF2711014495D4C16545A512592EACFF470373FC1D123F77011690A257AC19232619C855BA3157CA0D98DADBD2A06428FF024108D1C7562DF7E50443BB788F498AFDF127AF4398DF7153975B279E2CC5023874E91FC029DBD840EC0FF6B3C9D45E347F28CDE8BE6DA13CDB5272062CC675FA6CE1E9F6B0F8E106BC37C0F1041AEBD16864DB6D9D98467FE53523D2E3921AF069398888B200F03F1298632ADB0A6E5E1BDA106F450E97CE33834461419673B3939EE9D3B9C95BFE23FF57974FB4484A9DDE1A0517AD5DE94695CE7A878BB4BE23A9C8E19C9B5760C0D63854F73CAE3D181F30292B14132361A2807F585E6A19C6EEEF93A6CD051223439E6F76FCE375FFF58D07EF8E65FB26F3DB480E1DE651080523F0022026C3AD9858CC84053BDF05029D82AB36342923CDF562128B4082478625B655616A155E6ABBE555AD9435B55B7086C2D87B4246F05D202847A7B992C6BA4FD686CABB9D804B549ED4965ADD24F2219DBDD256D80B4CC3AC5CA1A674B98DB0FA9F22016382F0D190F5C1133135CFA0A231B8D72171A6F3EE89BAC7419B419E1A44AD1AA500EC2441D76BFA6DE8C8471C51CBE2A3862CA80B809E8036613238CE6135860BEEA1BA7030691D82EFBDA8F21586F4295165751755C9FDA7468BBCDFD2E6836851D49D5677EE70F39D86EC2442044A0C9BBAF0F54E359E796D486F3F66773C7659DF6D36126F449DE597574947864C5B269EA9A9D60DC3AA88DF29177181E18A4397565BB447DD08B84F3710052E92A1A41CF19E4C297EF5928322DDD1061BF79174B35D3CCE2901D22B9CDE3EEE273EBB6E9354AA90C6C9CFAF98E490D9FA673DCC77D1491D2CF1C222A98937A7F229338A55B50F330B12A5F69C0CC923855FB5F61DC05EB4114ADBE330B43E138EBD3DE186A32891EA7A6FE4B3D53FD63C164C574EDAEE04369EAB7DEE9F2806D10B353A04434969E84D2736DAA4BCD4F1A9168B7AD1411A1446701C1FDDE248272749AF32630C98E5AF1BC7D774159B8794924E5EA247690A2827A3581A79EC121EAA02720B30EABD7245931DF42185035B7EE29EAC31FD17BA5EB6140BFE71C823785BE6BAAABBC6E6752C377D9E4256038DD83FA17F881F730477CFC1DB8410407DD5DF525AFA4D7C01B61AF07BB9223EFB23EF33B580CC233F5EDB7B35975625EFF80FF149EA33F9BDD90F75ED65552BB338CF8E87E47E20CD34C50E957B723DA94B94A56697375CB71D414E172F05DA32220378BAFB3225A0561813F8728CFA3E47E3AF93588B7B8C8255663CBABE4D3B6D86C890980D55AFC4C0B83DCFCEADA3F9B093C9F7D2AD31DE73EBA80D98C482AE64FC99B2D362B5BBEDF4932472A48902BE53A0D3619CB82A4C3BE7F6E297D4C1320A15A7CED4DF82D5A6F624C2CFF94CC039245DF9EB72F39FA80EE83F019FFFE182D496CA68A88792058B19FBD8D82FB2C58E7358D5D7DFC27C6F072FDF4D7FF036FC9C2443E6F0100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201607142028454_V5.0.0_BlockLargeCommands', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5D5F73DB38927FBFAAFB0E2A3DED6ECD5AB667676E2665EF56E238B3CEC649CA72A6EE4D455390CD0D456A48CA63DFD57DB27BB88F745FE100FE13FEA30182A494F353621168341A3FA01B4077E37FFFFB7FCEFEF6B48E278F28CBA334399F9E1C1D4F272809D36594DC9F4FB7C5EACF3F4DFFF6D77FFD97B3CBE5FA69F26B53EE7B520ED74CF2F3E943516C5ECD6679F880D6417EB48EC22CCDD3557114A6EB59B04C67A7C7C73FCF4E4E66089398625A93C9D9CD3629A2352AFFC07F5EA4498836C53688AFD3258AF3FA77FC655E529D7C0CD628DF04213A9F5EB7F45FFFC7364347F3DFE2B74111DC05393A7A9FDEE547979874F15C129A4E5EC75180799CA378359D0449921641817BF0EA4B8EE6459626F7F30DFE21886F9F3708975B05718EEA9EBDDA158776F2F8947472B6ABD8900AB77991AE2D099E7C5F4B6DC6577792FDB4952A966B2524D2EB52B6E7D38B748D1B5812514E277C7BAF2EE28C94B593FE1145F3BB894DCDEF5AA41D1FFD74747C74FCDDE4621B17B8DA7982B64516E0129FB7777114FE033DDFA65F5172FEE3CFE1F7A77F39413FAE8EFFF2E34F6140F716F71797637EC03F7DCED20DCA8AE71BB4126570B59C4E662C89194FA3A520AF5E09EC976D84FFFF711BC7C15D8C5A84CDB494E661166D8ABF07F91B8492F9268E8A86DC9B348D51905853BC454F2D0D0C7C3CBBA793EBE0E9034AEE8B073CACC1D374F22E7A42CBE6979AEA9724C28B01AE54645B646EF563F018DD9790E1DAC7233C2FD0A682D70D8ACB32F943B4A9E6E611F57DC140F15D96AE6FD29825411759DC06D93D229D4BF5E5E6E9360B2D58AE06E14D50E0C9954B9966A8B3A5776C2B0BB50C358CAB4B365DA4593F9BEDE6B0766633A2F734B3299A0731B3297E5D663657BDC3CCAEC7985068A6A17252FE70EC654E721CDCA01C0B7C8E8AB7282FA2A44441852FBE6BF6742E32B44409D1A7A48CA66B27A73F81FAA667E14B92072B2463A4321B0C4C40173D57266EC9A80CC28346F3182A0E3B602E38BB4A22C2DF0D2AB2E7ABA440D923B612F38602FEE5FB53EB39803B16ADB76BAF3419626F82F06BBA5A5D634C44587DA3AC152D166CEC326931F1D74581D69BA2239F6421BBC5B677BA2DACBBACD4958CCAF6ABDE792D6932032C2D12B966AF3F2E18DD29F04A7F5699214C195B1344BD561BA5ACAB2A17BABA86760C34D56C8704D8357D37002C6BD8B3B5AA7C5B5487624D895694AA64CDE1C7EDFA8E2C83804A440E8E565A47EB4C64B7EB4ABB63C88D4607CB53B7F299163DC562A79A55E537C705D8A4336CD6600D7BC2EA61C1668D091597F5E7A6959CE392FF2CD314421999A6B0599B7CAE4B87BB260DB16678329C2D5B7D8B6254E05DC76F5BAC75D19218740D13786450F5B7C1B0CEE7CFB8EEBAEBD112D96B2DB731DECF06592167C491E265A2E89823BDC63A1F71F7CDB372916E93A29B8AB84C48E165D761C4E65B79E6542E746AA99C9CF67E5058AF1F4ACB7CC19461D65AFA934C1B30DF6D35C187202F70FDCB27146E0B8D3E680B2CEA1A1C93C2779946100B755509AD16F3A7196A9287AB209C8CD603B0445D6C3FE8B49280553AED7C6DC46DCD2BC9B4579A60AE73895A03FCCDA696E8A1CCA7966147CB8BA9DF6DB2ECFFC6CF7810DB5A375DAD1DB51D6632249CECC89BF4F756B5D426489404D9F37442AEF5B7598692B044EAF9B4341C187B42611C0B5DA6E6D7BC4833F40B4A5086195C7E0E0A6C4925E511E4665B20C079F22AC31A35DB86648ABC0BA218FFD3F14CF5A2EC65711BE45FFD1CD27E444F4579E68BEDFCE0B9EBD1F4DBF4635A91FB82978DD865903F442B143E87F15876F355FE3A2CA247D4D5CA75B981F81C90C1D5AD57A609926A6BDB8AA2BC10C1487F9766CD760234A4EAD3FB87285ED21C2A75F1CE2A95D55158B96251998ED6967738B4B9089210C57100B3D4850A8ABE70E5F41DE10B3B9E9081B8AF0AAAB92ECFC14CDC96851CB8240B1F0033BB926A3ECB024646AB52FE8FF29846DAB26A6E1BC3D2C46F53CE71CBE96FA7A96594DF8E5A724906C5B839660A2DC42D35C3BFBEB06C2762A861BB371197FEBE5746ED51806625055F2972CAC8DC1FB186A2377C413DD884D27E6F0B45BA0AAED5F7854299AEBB4656C3F8DB38D2745FF68EB69E15DA23F42E072D1673CCD5FCD0AE162A5BC515BEDCFAEE0FBF0CE1430130C3B42388051ADD8E307C91FA9CA1C728DDE6260E4D5BADFCEB88372DDFCA8EF5804F86AE519E07F7FDBB3F5E3E91E891487B71E5A7A57D3FEBF2A78E801B35930262B773BE6FDA7C6E2624062070FB01DE4C28965558EFD4B535BD545532F75659B39311DC54F6643B54E486B71826AFEF725C322CEA55C3C182D81D44DADA0DF2234C5BB3F75017B2720B5C89E0972CDD6EAE11B9AF2113477E00252DBAA0A8D0F3C7585858EFCC351CAF4341AED4204F585D7C948647CB39CD89C0F314E7A81FC41EA13A3B52CD7369150A372E2B03DF6297382596934ED71561BC5DDA9BC19015608819CF6B4AF81A6177C848D1B5E896A4AEA97342156017C57A1E4C819A67FF8BC50846C11B4CB9DE7F9001C3D33A43F903C1782DA86FC48F140E6437E5EC05D33045AD9E0B1D30FD3ACFD330F27BCA2B507E51817BAC029D75173586B532A16A50A3CFECCCC195844901AFE97671A6E9A9B03A327351D555782DA1AF16553BAD01824CBDAD0102E5F1751C44B1CDB777AD67B97588793912E5CAEC493F1A4E4851F688324353A73FFCD88B2AAE076E204300B246B1D370F8F58A374CED57BA2E91B6363B71AFE1B6BA1D3B204AD769D912AD555FCB9640796F962DFD319EE44C9A1C57117B7959F7097EA1025294C6E9D6BBD2E4279C83BE7542DFE513390F24591EFA42A1B285F1D128E9B40D300F49BFD65DF59E7644ABEC6C4CB7CB184FF328FC9CA6B17FEB4D203E3EF6D4136F6FED244A8AFB869E4A2CFE8143D37DC18CDF217B08B2E575B0E961D018CA873B6C7537AE8324B847D998339F6365E00D938299FD5A83766903FD417947F3200E1DB5593CA535A81EBA46FCFACEFDC930D32934AD4E38E827FFA7AF7C601D3367F21B64738E4DC86CA2B633E25D3C93B68C95C265B29C007398ED5663E670A1C9131762AECEA77F12E46C6EA195C8AE05660CD8168E8F8E4E8446F07C405965955FE0C1C2F3334A0A71F24449186D8218C60F57DD69BECEDA36F92F6FD1062564230113BF1766DA36B905C224BDB319052F23EA8498770D1ED401F00CDA5A771F160A220EF4C425407BDF449F9960EC8A30550F2103FA5E9EF64155D694ADCC0A8C2AE18DC1F730B8657248686025CFD3C240CA12A8F214159019E00FA7B25E75186B3BB0C904D0A9F16110A38D9BD38C372CBC98197FCA6516A00EE1ADC9D1A66CCD1FDE203200424013C9620B4488AC205CC9C3EEC7C7291FAB05828D2A160B8819303C9501624C3B6CAC598FB6A1510063C253212B3F2C8D80CAD20883A284CD07E0BA7219E8C38DC5FE50473332BCE1253F6F9026B8ED04647A38F7BE97C3CC0D43709006C8D0482106D55C508EAD85014D75E06AD174919D32F408DC1F731C125C968655C8328CA9EB20BAAE51766C02A7A92126D97685B11B43904DA7892CDE0B1D5A853D42951C97ACC6BF2DC705597699245E9429D3E1916D374636076BB43587125044081987FC9B6E7CB222C773442F80E378D9F7133FDD507DBBA77E621A2A10D4849C54FE4F6B8404CBDA23C6AE5693266712885B750225CF935C997BC95985759FEC2A9EC6D432AA0181F024CBFA38CA0435C743AA3063111CC9FBD60AE1C070A4C2032C251EBDBDE014CC1104179A6828384AC12303E1481B72351048E181042AD8384415ECE02309DA811BED0EF1573C709990C15E2C796BF10C86656BF11D0AA62DBCF555D07271DDD73A96C351ED126A373CACED053418AEED0508BF151B19D972F523C66DDBA9784D6282DECD0B4D00B9B4ED412D0D257323DB1BCA013B18201B371CAA1D94DAFEF5B241B335747BBA3E1BC9BAD548BA2B0FC360AA7D465133D8E29B8A0E1E75728AB0D38E135E98679F922A1DC88464AE4C497AAE200F83A5E8F73BC3EDFAC11ACF738743327B47515AFC9D1A1E1655ADDF30000BE2D398BE50263E7C0C726EF6EB772C63043892F4B3AA7EA0C4CBDA0B23C341CB14C76EC004F80D69AF3EF090287A8B6D7E3F8EF166268754AD1683053AE75452D90B405B80B757A08E6AD129B81805750767CFA9639554E36E0E478285E9E88E6700C151D4BA478705F6720E63EC32E8D0CE5B2490513A5ED8F10EBE2A2E0DD729700D94B57C24459612524519C527C4757EC9511DDA994B13465464F1122D8BCEDBC5C2C90029E08FA5C42C8C0225E62B8C52AE260321A1A80EA9BA7BFA5446A1F57A3013A2E217A4A4A8D3013331DA4159418F75E6369364FC86143439DF2203D16A4EC948356B118880983252414F38FD039167D3E328483327D606B25CE0AA40915975395A543BD2D9C4849B4EA8D292DC53CAC854A531228B4D6D7BC7CD6A61D98307A35224758BCA8C15064C50E2ABC05221E90329F9DE28432959E1EC960ABD7094C193A2AC055A6E5261DF70964A441DA2C7B32F0DD26359378A401A960793A69B04B4F1647289C043D0D407B69A2034B6B734377AD18162CEA0C4BB0A53D0330649F2E5813D7DAF0893EA2E439EB25C809CBAF52EC3CA8E31CB4E0CE5D1F68C09E6F1222B267CA7B7E5CAF47E8B545036711D7C1F81911D6C877983492F46602047BF1317FA740C40C0B0E00FBD148CE11FFE046E0CF8B069CAC38CAFDF51324F7949E4817686B2B1075E263D1B6D30B0A0DA1D965954529F796DCF78AF792FE2E2FDE487316BDA977E0D7292BA62ABFBC33B63779710EF7B6DB01CBBCA457CA6D62020BD8FB6BA5F4A2FEDEE2253FA65F7A82DCCEEC112415AFA14333D867B1553BD569D1068240BF72316DAF121578BD4D8A27C1DDD6199FEDB3BC49AE5E0D88052D0AC1C3ACBDC263FB22874577F4D46280E1E9B96627770CCEC5BEE507F40F04A62702504CC73B533611FAB8ADA7DB097B545AA230CEACEB82E4B4A7B546D432CB9CDBE556D1EC91DB3542E2E9AB35163CF0567AC5ECC1FC12548DF6DB9E7908A75C177A88318046F21D871B3BB548CAF32E8CFD4A17E305D3C613A9EB8035C5FFA9C65CC68EA85692538BF421A42209A64A6A25C80DE0496FE04B09B164B07028A28D72DB0C89A54ABED9576FBED6C36C7B4D641FDC3D98CBC3B8B36C53688CBE4C179F3E13AD86CA2E43EDFD5AC7F99CC3741483AF2E7F974F2B48E93FC7CFA50149B57B3595E92CE8FD66DB6E2305DCF82653A3B3D3EFE797672325B573466212377FE02BE6DA948B3E01E715F890C97E85D94E54563074F2717CBB5A4187381AFB8556C1A13EFE8C5416C6E1A9B3AE4FF553DABD4CE9A4676727E87BBBE26AE15E51BBE0AA409B571FD7918C441A64F947C91C6DB75527D0AAB4F8B2581A4F87A858E6A85CFBF07F91B8492F9268E0A9674F540C6E221C81777B8C422AF8AC01BA8F227D3242B5F0C49A4FE8C939BE036220C1F379B784480F0A2D7EE9EF0A2690480176D6D95E0A94A3C5EFE89D923E685035E9AACD8580C4D366C19120BFCDD86ACDE17926E212B4B2E72AC9B96BBB28BA25257769D91B5CABFB002683B6CAB2C92407CC248C7C197240F5648C647B5C88379A8166E8FEDDF926D32B8F98294B66EBD9F254D37821D864A0E4727DC5D251161E10615D9F315566DD923D6DD394B38AACA2C32526811D5A5166BC9C641DDD075F014ADB76B6D43EBAA4CB7869816DE04E1D774B56ADC2549821516424C437755E9C59A2A6ED9F0EBA240EB4D91CBDA09DA6F164A112F8EE431B2745BF0D22AD7CDA2FAA690D1B87A4C660EFB5562EE0ACC4A79499496E5347B2FE4F9E1E93DD6175189323DA30E223C872536AC59ECA0A4C7435ABF287343D8C0E812958BAD46913E214E135C9605F0CA5C9728171E2B4593CF9F71C535A75AF2455EFF6CB3517840CB6D8CA8971BD97D42F5799193EFD68C36D4F12E5B431B25F622682837CA4965B9B68DB48AC9D686E55BBA48B789B09BE21B09AB42F0562E13626A71E845CD8F36E06BDF3EE441477DD8A73547E37BE96FE9517848C0562065E5BD5773E38DAAD663D4DFB82A9D156023ABA9AE19162685193F28A8BDE1B11EEEFDC04CCFA611DEC6B56F02735B38FCBBBD1E50E82D27752555532EDAE926FDBD75DF62F62EE9EFCD08D86D2C57599017D936248FC5BD0BA218FF236C2CE9328B555BC86268B659756B9B7F956FBDC2AAC0A2C0259C76601FD153516EEDB08D143CF39BB0047FADF7AB4BF2DD72B3FA36FD9856D4BFE0491E4BECAE7491A44D0B5B52C67A603F442B143E87B1D4D6889B8F76B61C492EF188045B2EA87F1EE52843FED6084D765396587459F2641921D9D992766BA03A90C116F6BB346BCC38111651536AB14AB3456BCBA9A0319E4E659DF1FB54ABBA50059866D553185AB96A3663E65DD87803CEF918F739E25A5776D8901B4868C65C487DCF8F7BA9703A5856BD804A97BB9F5929EB728BCE3D21CDA836BA2561DBBDED5EABB3FF1796E235CAF3E09E23B46E7EB460E889380B080627DAFDDCBBF53AD23AD9F8ADD8AC8E5739F9FFA7D51FAC96C9AAA53F3AAC8EAA240B035872230DA64FF5A4717BDD6FD993888F8B74BD21C7BDCBDA4D59B10CC5B8E8226CCAE23D4A59D8F1D8553CC3AED9BF2F5D71473DD0BE4893654456A4C9AF41BC458C03B19467954EDB27848A79B40E0AA7F3ED5D7B382C1CF150DFECFD304A77BC726C454C66F5674754CE5186D72F916C5EFE6E0FF27AFC4482CBFA8B8EA4806A0A11878CEA4BB22E45E1E7348D0F11D8632DC00739A16AF9E83DA52AA974F0B7F13C6D29808A3451F571B1C15F6D672F45F890277025EE97B9FB3277479DBBB21956513BE8C9F510644B4CE6657ABD4C2F1FD3AB86D3759004F728F3AC2939EADDEC5D6D0B1296C997C53AD04A5EBA46D424075D253A1D4409C1B3431C8B50B9FF5C1721231DFD55A17C65AA2F099D1628EEC522E604987C72A37A9584F17629DC00D63FEE19960C21F65E7144277A74C59096C661E167A471374540FAB25DA84C9CF683ADADAD1C8E1EE3DC4A56641E4F7598DB1DF9EEE0F2D4444509B16E6D3CD448316F6C7CA9FEDE589246CED335B184B28D8F1D89BD35DC052B33D2891277BA5B2E2D5BE0B56CF9C84B43DF475794BB861E6EB1B5CCEF0CAFABFCE3368ECFA7AB20E6CF2DE1A2E2C39F5D102C49EFE5C14974470C1067201F536582300FC3D88AD837109539C8E04C437D533D02AD1BC684487BBE48BB46D7BFB47FB791F675943B137E5F8A88C46496A2C9EB887B3EECBD2A329D60413C464B12F25E056C1C910204AF17718448804053006FCAA215CA8BDBF42B4ACEA7A7C727A7D3C9EB380AF22A4D421DD0FF8A4F750F8AF03FF99E44F8A3E57AC657B7CF1340A8E4F93296640920135454F65C74FF3F90800AF1A10183417036E3A99C718015085459C8B749F4DB1645E5FE7C554624121492188B1689332D5D45D87C45FD8EFCD79260654054F593C7200BF17EF70FEBE0E98F064AB401A11D09658C396C240CD16AE6911008781A0936229D15E074721D3C7D40C97DF1703EFDE1D89AB639165DD509E1258AAB64899ECEA7FF59527E35B9FAF78589F877934F195E105E4D8E27FF45735E3E63E1C6B87024A511D7C9E94F9E5A6542D70D08EFD00C1DA2EEA115F0CA01186A8E569791ED7908FD40DB0B863501F2156B5162BFCC6A82E1DD890202DE2BE2190A6247EABB200B773E85D87628295B25E3A860E476A4BCA8297C49524D11A304525D5D674445622172AE9A21A0019509821A532F7C9D38F0D54ADA1DAB607301D6499A9685C86D80EF0FF4DD1169296CB926014AB6D4430BA9E7DFA28D44DFC9FC3BBCE5FB5232FC6A728BD5001903B5CE02B1AFF03AACFA83071D91BF4F7BEAD089AC439F33144679B92DFB376BBDB78BDEA7B613BDF07E2AE3DD7A2724490C20885E2510BB26767EF53D35C0E506F0BB9B502607705F25DBBC00EE1B4F261D80AEC3E420C292B6E204A7C3522EA508B7326DD67369B0FF08B6CC80F6499FC688373DABB846808F8CFE3811226C189C1DE4D79795B9A82DB27DB53605FE7C599D5E993A75DAAEEF42D43C2B2D177D0BE1D941CB828E6DE838A37A3F9CFEDEFE525EC4FC8212949108ECCF64BF9B25E501F2665B101567291E651A04776DABC87AE04E509AE7C09D9C32AD81D771A4A241FDDA47546C688773F4FD39C0522646E8C0988266A7B3627972852E27DB328A9D548F3633835F746B6EB77DD8AD02D97E8C5775D685FDB393803ADA1B988CE704166AD9664C346911E0830270BA808C8C05BA1DACC4FD1C7753FA852ECBB2967497D599CAE6E057DBEEB71AD7DBCD40E4B003912F28A2BA43BABDB5BE1DBBDD50EC7A30D926A3F070BB4AA5A3F07123DCE7D602BCC4CB5CA9600BBBD201D9BC9803EC5D5BF538EC3E0D1053E4757E491220F8BD4287DE4674E984101F651E7BA06785181CE5573A4CCC9286F4E90F3F5A0B9E0D57F2EDDBA288EAF2DB8C2450D9B3FCB900AC5EDC478CF68AF996CF72D5D5062DC11661738889CC41511F40625EBFC556BB9F0E184F2F602618DFB52E0E502CAD8E6701758C16D4BAB484923276E90546870B23300694214D5E1C96E57E49E6D8248F8ECEFEDC156D1CA5D9CE75388267E2ADACB70E2A1850739EF5642B1F01543BB14B1F0D6CF8E25F35C41AB0F6080C310BE7D3E3A3A313A1BFD2C71A198ACCEF2CC53F09E430CA5056D92B17782F58644124C6A07DCEF09A1A6D8258D217AEAC23E8676D13FC97B76883F7A724B850ECB5A7B6DB26B82965920D135A62444BED2ED03CE99A2B9142B91670C3DAFECC8E2A00243280F4040E956784627C54AE108ECE102E581A8BCF6170B778AF7A398385090F114B94D941D61FD63A0D9E1D567CC07AA851DF05F295D1EDEFD5EF6C289E1DE70792FA60ABA5DAAA557C1A90AE3F88E8B255DBDF6CD9A286ED3D840370C2FCE1C1A4BF39EC8824038C9886399AEC3700400F134B866CFB6E0C8C8021490C8893C962B1F68CB0EE8C675BC8B791AA27781CD7B3C3E8DA30E83664BBD00094BDF4E740CA7D3C24F09B9E8970F45EE817AD76593EC68096EA2989B120C65497D9775AFADF1CDC4471800C3ECB773F46D1D9A46B9EB70E36D81A0957E3DA7B6EA8DE43F0C86365FA3BF31A53F31DD0E9D7C8B6DCF0506CD23A0D7C02623A5BFB56D62B3B236BDFD629FE95C14195DDCB21999DCD047CF2711014495D4C16545A512592EACFF470373FC1D123F77011690A257AC19232619C855BA3157CA0D98DADBD2A06428FF024108D1C7562DF7E50443BB788F498AFDF127AF4398DF7153975B279E2CC5023874E91FC029DBD840EC0FF6B3C9D45E347F28CDE8BE6DA13CDB5272062CC675FA6CE1E9F6B0F8E106BC37C0F1041AEBD16864DB6D9D98467FE53523D2E3921AF069398888B200F03F1298632ADB0A6E5E1BDA106F450E97CE33834461419673B3939EE9D3B9C95BFE23FF57974FB4484A9DDE1A0517AD5DE94695CE7A878BB4BE23A9C8E19C9B5760C0D63854F73CAE3D181F30292B14132361A2807F585E6A19C6EEEF93A6CD051223439E6F76FCE375FFF58D07EF8E65FB26F3DB480E1DE651080523F0022026C3AD9858CC84053BDF05029D82AB36342923CDF562128B4082478625B655616A155E6ABBE555AD9435B55B7086C2D87B4246F05D202847A7B992C6BA4FD686CABB9D804B549ED4965ADD24F2219DBDD256D80B4CC3AC5CA1A674B98DB0FA9F22016382F0D190F5C1133135CFA0A231B8D72171A6F3EE89BAC7419B419E1A44AD1AA500EC2441D76BFA6DE8C8471C51CBE2A3862CA80B809E8036613238CE6135860BEEA1BA7030691D82EFBDA8F21586F4295165751755C9FDA7468BBCDFD2E6836851D49D5677EE70F39D86EC2442044A0C9BBAF0F54E359E796D486F3F66773C7659DF6D36126F449DE597574947864C5B269EA9A9D60DC3AA88DF29177181E18A4397565BB447DD08B84F3710052E92A1A41CF19E4C297EF5928322DDD1061BF79174B35D3CCE2901D22B9CDE3EEE273EBB6E9354AA90C6C9CFAF98E490D9FA673DCC77D1491D2CF1C222A98937A7F229338A55B50F330B12A5F69C0CC923855FB5F61DC05EB4114ADBE330B43E138EBD3DE186A32891EA7A6FE4B3D53FD63C164C574EDAEE04369EAB7DEE9F2806D10B353A04434969E84D2736DAA4BCD4F1A9168B7AD1411A1446701C1FDDE248272749AF32630C98E5AF1BC7D774159B8794924E5EA247690A2827A3581A79EC121EAA02720B30EABD7245931DF42185035B7EE29EAC31FD17BA5EB6140BFE71C823785BE6BAAABBC6E6752C377D9E4256038DD83FA17F881F730477CFC1DB8410407DD5DF525AFA4D7C01B61AF07BB9223EFB23EF33B580CC233F5EDB7B35975625EFF80FF149EA33F9BDD90F75ED65552BB338CF8E87E47E20CD34C50E957B723DA94B94A56697375CB71D414E172F05DA32220378BAFB3225A0561813F8728CFA3E47E3AF93588B7B8C8255663CBABE4D3B6D86C890980D55AFC4C0B83DCFCEADA3F9B093C9F7D2AD31DE73EBA80D98C482AE64FC99B2D362B5BBEDF4932472A48902BE53A0D3619CB82A4C3BE7F6E297D4C1320A15A7CED4DF82D5A6F624C2CFF94CC039245DF9EB72F39FA80EE83F019FFFE182D496CA68A88792058B19FBD8D82FB2C58E7358D5D7DFC27C6F072FDF4D7FF036FC9C2443E6F0100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201609140552329_V6.0.0_CorrectedViewColumnTypes', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5DCD72DC3892BE6FC4BE43459D66267A54923A7AB6C721CD842DCB3DF258B6C3254FECAD82624112C72CB29A3F6A6937F6C9F6B08FB4AFB000FF0AFF48802059E5D5C956114824121F90092033F1BFFFFD3F677F7DDAC4B34794E5519A9CCF4F8E8EE7339484E93A4AEECFE76571F7C79FE77FFDCBBFFECBD9E57AF334FB475BEE47520ED74CF2F3F943516C5F2D1679F88036417EB489C22CCDD3BBE2284C378B609D2E4E8F8FFFBC383959204C628E69CD66675FCAA48836A8FA03FF79912621DA1665105FA76B14E7CDEFF8CBB2A23AFB186C50BE0D42743EBFEEE8BFFE8F324347CB5FE3B74111DC06393A7A9FDEE647979874F15C119ACF5EC75180795CA2F86E3E0B92242D8202F7E0D5D71C2D8B2C4DEE975BFC4310DF3C6F112E7717C4396A7AF66A571CDAC9E353D2C9C5AE624B2A2CF322DD58123CF9B191DA82AFEE24FB7927552CD75A48A4D7956CCFE717E90637B026A29CCFF8F65E5DC419296B27FD238AE60F339B9A3F74483B3EFAF9E8F8E8F887D9451917B8DA7982CA220B7089CFE56D1C857F47CF37E937949C27651CD33DC47DC4DF981FF04F9FB3748BB2E2F90BBA13FB7DB59ECF162C89054FA3A320AF5E0BE99732C2FFFF88390A6E63D4A16AA1A5B40CB3685BFC2DC8DF20942CB77154B4E4DEA4698C82C49AE20D7AEA6860B0E3193D9F5D074F1F50725F3CE0A10C9EE6B377D1135AB7BF3454BF26115E0070A5222B91B9D58FC163745FC1846B1F8FEAB240DB1A525F505C95C91FA26D3D1F8FA8EF2B067EEFB274F3258D59127491D54D90DD23D2B9545F6E99965968C1723D086F82024FA85CCA34439D2DBD635B59A863A8655C5DB2ED22CDFAD962376FB5B39911BDA7D94CD1DCDBD94CF1E8329BB9EA3D667333AE84423BF59413F1A7632FF390E3E00BCAB19097A8788BF2224AAA91AF31C577CD9ECE4586D628217A9394D174EDE4F46750DFF42C7C4DF2E00EC918A9CD838999B821A3320A0F1A6D63A838EE80B9E0EC2A89087F5F50913D5F2505CA1EB13598B714F02F3F9E5ACF01DCB168536EBCD26488BD09C26FE9DDDD35C644845536CA3AD162C1C62E9316137F5D1468B32D7AF24916B21B6C63A76561DD65A57E64D4B45F95CE6B4693EAB7B442E4DABCF9B862F4A5C02BFD59657A30656CCD0EF55A6D94B2AEAA5CE8EA1ADA31D054B31D1260D7F4DD00B0AC61CFD692F26D45EDB305255A4EAA920D571FCBCD2D59FA009548DF1D2DB39E1699C86EDFD575C7901B8D1ED6A66EB5332D748A054E3593AA6F8E8BAE494FD8ACBB1AF68415C382CD06132A2E9BCF6D2B39C725FF59A61D843232ED60B31EF95C8B0E6B1D1A639DF064205BB6FA16C5A8C0BB8B5F4BAC5DD19A186E2D13783450FDB7C180CE97CFB8EEA6EFB111D953ADCB18EF5B83AC9033E248F1325174CC915E6B854FB8CBE659B948CBA4E8A7162E135278DD7718B199569D27558B9B5A2A27A7831F02366B86D2025F316598F595FE24D300CC77DBD5FF439017B8FEE5130ACB42A303BA02ABA606C7A4F05DA605C4427DD540A7B9FC698386E461290527E3F4002C4E171B0F3A952400954E355F9B6C5B334A32D595A696EBFCA1E6BDBF19D411DDE739D431E9686131F5FB4D90FDDFD4190F563B2BA6AF55A3B6B74C068393BDF825FDAD53218DA9112541F63C9F91EBF832CB501256E83C9F5706026337288C60A1CBD49C5A1669867E4109CA3083EBCF41812DA6A43A52DC9605029C0FDF655873666548A6C5BB208AF13F3DCF482FAA5E163741FECDCFA1EB47F4545467B8D89E0F9EFB1E35BF4D3FA635B9AF78A9885D06F9437487C2E7309ECA3EBECA5F8745F488FA5AB32E370A9F0332B8BAF5CA3441526D6D5B5154171C18E9EFD2ACDD368086547D1AFF10C56B9A43A5FEDD599FB23A0A6B562C2AD3CBDAF20E0732174112A2380E6016B95041D117AE9CBE237C61C7D32F10F7754135D7D5199789DBAA90039764E10360665752CD6755C0C8685DCAFF311DD3485756CD6D6B4C9AF86DCB396E2DFDED28B58CF2DB4E4B2EC9A01837C14CA195B87566F8D71796ED3E0C356CF723E2D23FF4CAA8DDF26B5652F01521A78CCCFD116B287AC317D4834D28EDF7F64FA4ABE05A7DFF2794E9BB5364358CBFCD224DF765BF08F18ED01E8FF73950B19857AE2687768550D927AE90E5D6747F986508EF336819461D812BD0E87754E18BD4E70C3D4669999B38346DA9F26F13DE9C7C2F3BD3033E01BA46791EDCEB6E3BA13EE206F69E487447A4BD88F2D3D2BE9F69F95341C00D9949E9B0DB36DF37673E370D12430FB8CD006F1A14CB2AAC77EADA9A5EAA2A997BABACD9CBD86D2B7BB2176A72E35809B3D7B739FE1A16CD4AE16035EC0E196D6D05F9F1A4AD797BA88B57B5BDAD45F04B9696DB6B44EE62C864911F2E498BAE282AF49C311616D638730DC7EB4D90DB33C86B5517BFA4E1D1721E7322F03CAD39EA7BBB17A8CF8254735B5A85C28ACB6AC0B7D8278E88E5A4D7F54318976B7B731732EBC798E5BC4684AF0B768786145D8B6E49EA9A3A2754017651ACE741E5373CFB5F204652FE6F30B5666F4106094FE50CE50F04D78D70BE139F4F3878DD94B0171CC314B21AFF3D70FC3ACFD330F27B522B507E51757BA6EA9C7514356E8DD2A06A5023CEECB4C195848900AFE976E1A5E9A9B02232F34FD555782DA1AF16557BCD7B41A6DEE6BD40791A5D065160CBF2B6F3F6B60EEFAEA45FADC09EF4A0E19413658F28333475FAD39F0651B9CD608DA4F021EB123BF5C65FA378A3D37E75EB13E56AB3B3F61AEAAADB810322649D962AD12AF5B5540994275DAAF4477192B36472E4446CE175D30FF8450848211AA7D8E0CA919F640E7AD50971974FE44C8F6455180A79CA16F665E36705C643D2A34D57BDA7F6D02A351BB3EC32C6533B0A3FA769ECDF3213884F8337F504DB5B1B8892DCBE21A6168B7FB0D0745F70D27F981E826C7D1D6C07182886F2610D55C3FA759004F7289B728673AC8CBCE95130B35F6BCD2ED59E3FF8EE68EEED01A136DBA5B406D52BD7485ADF393219667A857F3549FAFCE4C9F49543AB6786497E636BCE45099941D49644BC1367527DB152B84CD63360DEAFDD0ACC1C0AB4B9D542CCD5F9FC0F829CCD2D7412D9B5C08C01DBC2F1D1D189D0089E0F28ABADEC0B3C58784E4649214E9E2809A36D10C3F8E1AA3BCDD745D726FFE52DDAA2846C0C60E2F7C24CD726B74098A477B6A0E065449D104BAEC1833AB09C415BE776C34241C4819EB80468EFDB082F138C5D11A6EA216440DFCBD329A8CA9AB27D59815125BC29F81E07B74C6E060DACE4394F18485902559EFA013203FCE154D6AB1E636D073699007A353E0E62B4B1699AF18685F032E34FB9AB02D421BC3539DA94ADF9C31B4406400868A2486C81089115842B7968FBF438E563A340B051C53E01310386A732208B69878DED1AD036340A604A782A64E587A509505919615094B031F7AE2B97813EDC581C0E753423E31B5EF2F3066982D85E40A68773EF7B39CEDC3004E668800C8DD26150CD05C4D85A18D07402AE164D1FD929C37EC0FD31C700C1656958852C4388FA0EA2EB1A65C726709A1AE2816D5718BB3104D9749AA8DEBDD0A175C82154C9710961FCDB725C80639F49E24599321D9ED876636473B0465B7B2801458490D5C7BFE9C62704723C47F402388E977D3FF1D30DD5F77BEA27A67A02414DC8FBE4FFB4464856AC3D62EC6B3569F21281B8552729F23CC995F98D9C5558FFC9AEE2694A2DA31A10084FB2CC8A934C50738CA20A3316018BBC7FAC10960B472A3CE851E2953B084EC11C4170A1895C82A3143C32108EB4E1512381141E00A0828D4334C00E3E92001BB8D1EE102BC5039709E91BC492B716CF6858B616DFA160DAC2E35E052D17F77BADA3381CD52E6171E3C3DA5E40A3E1DA5E80F05BB189912D573F625CB59D8AD7240B18DCBCD004784BDB1ED5D2503237B1BDA11CB08301B271C3A1DA41A9ED5F2F1B345B4377A0EBB389AC5B8DA4FBF2300EA6BA670835832DBE49E8E05127A7083BED38E18579F629A9D375CC48D6C894A4C90AF230588B7EBF0BDCAE1FACF13CF73824B37714A5C5DFABE17151D5F90D03B0203E2DE90B65E263C120E766BF7EC732468023493F4BEA074ABCACBD30321EB44CF1E7064C80DF5DF6EA030F897EB7D8E60FE3186F66724CD56A3158A0734E2595BD00B405780705EAA4169D828B49507770F69C3A564935EEE6702458988EEE7806101C45AD7B7428E020E730C62E830EEDBC450219A5E3851DEFE0ABE3D2709D02D74059C747526429215554517C422CE7D71C35E19CB93401444D162FD1B2E8BC5D2C9C0C9002FE584ACCC2285062BEC228E56A3210128AEA90AABB274565143AAF0733212A7E414A8A3A1D3013A31D9415F458676E3349C66F484193F32D3210ADE7948C54BB16810888291D15F484D33F107936C58D823473626D20CB05AE0A14995597A345B5239D4D4CB8E98C2A2DC919A58C4C551A23B2D8D4AE77DCAC16963D78302A4552B7A82C5861C00425BEB62B15923E9092EF8D32949215CE6EA9D00B47193C29CA5AA0E52615F66D64A944D4217A3CFBD2203D9675A308A461793069BA49401B4F2697083C044D7D60AB0942637B4B73A3171D28E60C4ABCAF30053D6390245F1ED8D3F78A30A9FE32E429CB05C8A95BEF32ACED18B3ECC4501E6DCF98601E2FB262C277065BAE4C6FA748056513D7C1F71118D9C176983798F4620406720C3B71A1CFB600040C0BFED04BC118FEE14FE0C6800F9BA63CCCF8E60D23F39497441E6867281B7BE065D2B3D106230BAADB61994525F599D7F68CF79AF7222EDE4F7E1CB3A67B4DD72027A92BB6BA3FBC33767F09F1BED706CBB1AF5CC4A7600D02D2FB68ABFBA5F4D2EE2F32A55FF680DAC2EC1E2C11A4A54F31D363B85731D56BD5098146B2703F62A11D1F72B548692DCAD7D11D96E9BFBD43AC590E8E0D2805CDCAA1B7CC6D721C8B4277F5D76484E2E0B169297607C7CCA1E50EF50704AF24065742C03C573B130EB1AAA8DD0707595BA43AC2A0EE8CEBB2A4B447D536C692DBEE5BD5E691DC314BE5E2A2391B35F65C70C61AC4FC115C82F4DD967B0EA958177C877A8841F016821D37BB4BC5F89A82FE4C1DEA07D3C713A6E7893BC0F565C859C68CA65E985682F32BA43104A249662ACA05E84D60E94F00BB69B17420A08872DD028BAC4DB5DA5D6977DFCE164B4C6B13343F9C2DC8FBAF685B94415C250CCEDB0FD7C1761B25F7F9AE66F3CB6CB90D42D2913F2EE7B3A74D9CE4E7F387A2D8BE5A2CF28A747EB4E9321487E96611ACD3C5E9F1F19F1727278B4D4D63113272E72FE0BB968A340BEE11F795C8708DDE45595EB476F07C76B1DE488A3117F88A5BC5B631F18E5E1CC4F6A6B1AD43FE5FD7B34AE7AC696427E777B8EB1BE25A51BDA5AB409A501BD75F86411C64FA44C917695C6E92FA53587F5AAD0924C5D72874546B7CFE2DC8DF20942CB77154B0A4EB072F560F41BEBAC52556795D04DE409D3F992659FB624822F5179CDC04B71161F8B8D9C423028417BD76F784174D2300BC686BAB044F55E2F1F24FCC1E312F1CF0D266C5C66268B361CB9058E0EF3664F5BE90740B5955729563DDB4DE955D15B5BAB2EB8CAC55FEC51440DB6157659504E233443A0EBE26797087647CD48B3C98877AE1F6D8FE0DD926839B2F4869EBD68759D27423D863A8E47074C2DD55121116BEA0227BBEC2AA2D7BC4BA3B670947759955460AADA2A6D46A23D938A81BBA0E9EA24DB9D136B4A9CBF46B8869E14D107E4BEFEE5A77499260858510D3D06D5D7AB5A18A5B36FCBA28D0665BE4B27682EE9B8552C48B2379502C2D0B5E5AD5BA59D4DF14329A568FC9CC61BF4ACC5D8159292F89D2B29C66EF853C3F3CBDC7E6222A51A667D44184E7B0C286358B3D94F474481B16656E081B195DA272B1D528D227BE6982EBAA005E999B12D5C263A568F2E533AEB8E1544BBECA9B9F6D360A0F685DC6887A7D91DD27D49F5739F96ECD684B1DEFB235B451622F829672AB9C54966BD748A7986C6D58BEA58BB44C84DD14DF48581782B7729910538B432F6A7FB4015FF796210F3AEAC33EAD391ADF4B7F4B8FC24302B602292BEFBD9A9B6E54B51EA3FEC655E9AC001B594D75CDB03029CCF84141DD0D8FF570EF076606368DF036AE7BD797DBC2E1DFEDF580426F39A92BA99A72D14E5FD2DF3AF72D66EF92FED68E80DDC6F22E0BF2222B43F240DCBB208AF13FC2C6922EB3BAEB0A590C4D99D5B7B6F937F9D62BAC0BAC0A5CC26907F6113D15D5D60EDB48C133BF094BF0D766BFBA26DF2D37AB6FD38F694DFD2B9EE4B1C4EE4A5749DAB6509232D603FB21BA43E173184B6D8DB8FD6867CB91E4128F48B0E582E6E7498E32E46F8DD064B75589559F254F9611929D2D69BF06EA03196C61BF4BB3D68C136111B5A5567769B6EA6C391534A6D3A9AC33FE906A5517AA00D3AC7A0A632B57CD66CCBC0B9B6EC0391FE321475CEBCA0E1B720309CD980BA9EFF971AF144E0FCB6A1050E972F7332B65536ED5BB27A419D546B7226CBBB7DD6B75F6FFC252BC46791EDC738436ED8F160C3D116701C1E044BB9F07B75E275A275BBF159BD5F12A27FFFF74F73BAB65B26EE9F70EABA32AC9C20896DC4483E9533D69DC5EF75BF624E2E322DD6CC971EFBA7153562C43312EBA0ADBB2788F5215763C7615CFB01BF6EF2B57DC490FB42FD2641D911569F68F202E11E3402CE559A5D3F609A1621EAD83C2E9B2BCED0E8785231EEA9BBD1F46E58E578DAD88C9ACF9EC88CA25CAF0FA2592CDABDFED41DE8C9F4870DD7CD19114504D21E290517D49D6A528FC9CA6F121027BAA05F8202754231FBDA7542D951EFE369EA72D05509126AA3FAEB6F8ABEDECA5081FF204AEC5FD32775FE6EEA4735736C36A6A073DB91E826C8DC9BC4CAF97E9E5637A3570BA0E92E01E659E352547BD9FBDAB6D41C232F9B2DA045AC94BD78886E4A8AB44AF83282178768C63112AF79FEB2264A4A3BF2A94AF4CCD25A1D302C5BD58C49C00934F6E54AF92302ED7C20D60F3E39E61C91062EF154774A247570C69691C167E261A775304A42FDB85CAC4693FD8DADACAE11830CEAD6245E6F1D484B9DD92EF0E2E4F6D549410EBD6C5434D14F3C6C697EAEF8D2569E43C5D134B28DBF8D891D85BC35DB032239D2871A7BBE5CAB2055ECB568FBCB4F47D7445B96B18E0165BCBFCCEF0BACA3F96717C3EBF0B62FEDC122E2A3EFCD905C192F45E1E9C4477C4007106F231552608F3308C9D887D035199830CCE34D437D523D0FA614C88B4E78B746B74F34BF7771769DF44B933E1F79588484C66259ABC89B8E7C3DEEB22F31916C463B42621EF75C0C6112940F07A1147880408B405F0A62CBA437971937E43C9F9FCF4F8E4743E7B1D47415EA7496802FA5FF1A9EE4111FE273F92087FB4DE2CF8EAF6790208953C5FC7922C0164828ACA9E8BEEFF3B1250213E34603008CE163C95330EB002813A0B799944BF9628AAF6E777554422412189B1E890B8D0D25584CDD7D46FC97F2D09D606445D3F790CB210EF777FB7099E7E6FA0441B10DA9150C698C346C210AD661E098180A7916023D25901CE67D7C1D30794DC170FE7F39F8EAD699B63D1559D105EA2B84AD6E8E97CFE9F15E557B3AB7F5F9988FF30FB94E105E1D5EC78F65F34E7D533166E8C0B47521A719D9CFEECA95526747D9416E96875BF0D82D7130000385A7DC67BE081F503782FC8D684CDD7AC4589FDE2AB099177270A0883AF896728881DA9EF422FDCF91422DEA1A46C558FA3DA915B97F2A2A6A026493545E41248A1F59D11358995C8B96A8680065426086A4CBDF075E2C057276977AC828D085827695A1622B701BE3FD0F747A4A5B0E59A0428D94A0FADA4FE80AB2E3E7D27F31FF046F06BC5F0ABD90D5603640CD43A0BC4BEC217B1EE0F1E7444FE3E1DA84327B20E7DCE5018E5D566EDDFACF5DE2EA69FDA640CC2FBA98C77EBFD91245D80207A9540EC9AD879DB0FD4009731C0EF1E439932C07D95ECB205B86F47992401BA0E93E3094BDA8A739D1E4BB99422DCCAB459CFA5290026B06546B44F863446BCE959C5E5027C64F4878C1061C3E0EC20BFA1ACCC556391EDABB529F0E7CBEAF4CAD4A9D3767D17B8E65969B9E85B08CF0E5A16748243471F35FBE1F4B7EE97EA7AE61794A08CC4657F26FBDD2CA98E95B76541549CA57894C911DCB5AD2217823B4169F6037772CA64075EC7918A11F56B1F5111A33D4ED7F7E7004B992EA107630A9ABD4E90E52917FA9C77CB28F6523DDA7C0D7ED1ADB9F3F661B70A6487315ED5B918F6CF4E02EA686F60329E1358A8659B31D1244B800F0AC01503323216E876B012F773DC4D4919FA2CCB5AD27D56672AC7835F6DBBDF6A5C6F370391C30E44BEA288EA0EE9F6D6FA76EC764BB1EFC16497A2C2E0BB00EAE52E4985076A836E2DC04BBCCCC10AB6B02BDD92CD8B39C0DEB5558FE3EED30091465EE797242D82DF2B74E86D449F4E085153E6B1073A598821537EA5C3443269489FFEF4276BC1B3414CBEFD4F14B15E7E9B91842F7B963F17963588FB88D15E31DFF259AEBADA5026D8226C0E3C91B92DEAC34ACCEBB7D86AFFD301E3E905CC04E3BBD6C7018AA5D5F32CA089DC825A979650524634BDC0E8706104C68032D0C98B1BB3DC2FC91CB1E4D1FDD99FBBA28DFB34DBB91E47F04C1496F5D64105036ACEB39E6CD5D3806AD776E953822D5FFC5B875803361E812166E17C7E7C747422F457FA84234391F99DA5F807811C4619CA6A7BE502EF058B2C88C4C8B4CF195E53A36D104BFAC2957504FDA26B82FFF2166DF1FE94841C8ABDF6D476D70437A54CB261024E8C6869DC05DA875E73255228D7026E58BB9FD951058044069081C0A1F28C508C8FCA15C2D119C2054B53F1390EEE56EF55EF69B030E1216289323BC8FAC35AAFC1B3C38A0F588F35EABBF0BE2AE6FDBDFAF50DC563E4FC40521F6CB55457B58E5A03D2F507115D0E6BFB9B2D5BD4B0BD8770004EA33F3E98F437873D91648011D3304793FD0600E86162C99083DF8D8109302489017132592CD69E09D69DE96C0BF93652F5308FE37A76185D1B07DD861C181A80B297FE1C48B98F87047ED3E3118EDE0BC3A2D52EF7C714D0523D303115C498EA32FB4E4BFFBB839B280E90C167F91AC8243A9B74CDF3D6C1065B13E16A5A7BCF0DD57B081E79ACCC70675E536ABE033AFD9AD8961B1F8A6DB2A7914F404C676BDFCB7A656764EDDB3AC5BF3D38AAB27B3924B3B399800F418E8222A98BC98A4A36AA4452F3991EEEF627387AE41E2E224DA1C4205852A691B3706BB4820F34E7B1B557C548E8111E0AA291A34EF73B0C8A68E716911EF3F57B428F3ED3F1BE22A749414F9C191AE4D089935FA0B397D001F87F4DA7B368FC481ED77BD15C7BA2B9F604448CF9ECCBD4D9E373EDD111626D98EF0122C8B5D7CAB0C9363B9BF0CC7F4AEA272767E42D6112137111E461203ED050251BD6B43CBE37D4881E2ABD6F1CC7C688220F6D2F27C7BD7387B3F257FCA73EBBEE908830B53B1E342AAFDA2F5546D7252ADEEEF2B98EA7632672AD9D42C358E1D39C087972E0BC80646A904C8D06CA417DA5793EA79F7BBE0E1B7494084D8EF9FDBBF3CDD73F21B41FBEF997EC0B101D60B8D71A04A034CF8288009BCF76212332D0D4EF3ED40AB6CEEC989024CF3775080A2D02099ED8569995456895F9AA6F9556F6D056D52D025BCB212DC95B81B400A1DE5D26CB1AE93E1ADB6A2F36416D527B5259ABF44349C67677491B202DB34EB1B2C6D912E6F643AA3C8805CE4B43C60357C4CC0497BEC2C846ABDC85C6DB0FFA266B5D066D4638A952B42A948330D184DD6FA89724615C3187AF0A8E9832206E02FA80D9C408A3F9041698AFFAC6E9804124B6CBBE016408D69B51A5C555541DD7A7361DBA6E73BF0B9A4D614752F599DFF9430EB69B3011081168F2EEEB03D578D6B925B5E5BCFBD9DC7159A7FD7498097D9277561D1D251E59B16C9ABA662718B70E6AA37CE41D860706694E5DD92E511FF422E17C1C8054FA8A46D07306B9F0E507168A4C4BB744D86FDEC552CF34B3386487486EF3B8BFF8DCBA6D7AA3522A031BA77EBE6352C3A7ED1CF7711F45A4F43387880AE6A43E9CC8244EE916D43C4CACDA571A30B3244ED5FE571877C17A1045A7EFCCC25038CEFAB437C69A4CA2C7A9A9FF52CF54FF583059317DBB2BF8509AFAAD77BA3C601BC4EC1428118DA527A1F45C9BEA52FB934624DA6D2B454428D15B4070BF3789A01C9DE6BC094CB2A3563C7ADF5F50166E5E1249B93A891DA4A8A05E4DE0A96770883AE809C8ACC3EA354956CCB7104654CD9D7B8AFAF047F45EE97B1830EC3987E04DA1EF9AEA2AAFDF99D4F85D367909184EF7A0FE057EE03DCE111F7F076E10C14177577DC92BE935F046D8EBC1AEE4C8BBAACFFC0E1683F0787DF7ED6C519F98373FE03F8547EACF165FC87B2F9B3AA9DD19467C74BF2371866926A8F2ABDB116DCB5C2577697B75CB71D416E172F05DA32220378BAFB322BA0BC2027F0E519E47C9FD7CF68F202E71914BACC6D657C9A7B2D896C404C06A2D7EA685416E7E75ED9F2D049ECF3E55E98E731F5DC06C462415F3A7E44D89CDCA8EEF7792CC910A12E44AB949834DC6B220E9B0EF9F3B4A1FD30448A8115F77137E8336DB1813CB3F25CB8064D1B7E7ED6B8E3EA0FB207CC6BF3F466B129BA922621E0856EC676FA3E03E0B36794363571FFF8931BCDE3CFDE5FF00D2F18AAE706E0100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201610182256189_V7.0.0_AzureResourceManager', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5DCD72DC3892BE6FC4BE43459D66267A54923A7AB6C721CD842DCB3DF258B6C3254FECAD82624112C72CB29A3F6A6937F6C9F6B08FB4AFB000FF0AFF48802059E5D5C956114C24121F32136066E27FFFFB7FCEFEFAB489678F28CBA334399F9F1C1DCF672809D37594DC9FCFCBE2EE8F3FCFFFFA977FFD97B3CBF5E669F68FB6DD8FA41D7E33C9CFE70F45B17DB558E4E103DA04F9D1260AB3344FEF8AA330DD2C8275BA383D3EFEF3E2E46481308939A6359B9D7D299322DAA0EA0FFCE7459A84685B94417C9DAE519C37BFE327CB8AEAEC63B041F93608D1F9FCBAA3FFFA3FCA0C1D2D7F8DDF0645701BE4E8E87D7A9B1F5D62D2C57345683E7B1D4701E67189E2BBF92C4892B4080A3C82575F73B42CB234B95F6EF10F417CF3BC45B8DD5D10E7A819D9AB5D73E8208F4FC92017BB175B52619917E9C692E0C98F8DD416FCEB4EB29F7752C572AD8544465DC9F67C7E916E70076B22CAF98CEFEFD5459C91B676D23FA268FE30B379F3870E69C7473F1F1D1F1DFF30BB28E302BF769EA0B2C802DCE273791B47E1DFD1F34DFA0D25E74919C7F408F118F133E607FCD3E72CDDA2AC78FE82EEC4715FADE7B3054B62C1D3E828C85FAF85F44B19E1FF7FC41C05B731EA50B5D0525A8659B42DFE16E46F104A96DB382A5A726FD2344641624DF1063D753430D8F18A9ECFAE83A70F28B92F1EF054064FF3D9BBE809ADDB5F1AAA5F93082B00FC529195C8DCEBC7E031BAAF60C2F58F677559A06D0DA92F28AEDAE40FD1B65E8F47D4F31503BF7759BAF992C62C09BAC9EA26C8EE11195CAA6FB74CCB2CB460B99E8437418117542E659AA1CEB6DEB1AD6CD431D432AE6ED90E9166FD6CB15BB7DAD5CC88DED36AA668EEED6AA6787459CDDCEB3D567333AF8442BBF4940BF1A7632FEB90E3E00BCAB19097A8788BF2224AAA99AF31C50FCD9ECE4586D628217693B4D10CEDE4F467D0D8F42C7C4DF2E00EC918A9DD838999B821B3320A0F1A6B637871DC0973C1D9551211FEBEA0227BBE4A0A943D626F306F29E05F7E3CB55E037860D1A6DC78A5C9107B1384DFD2BBBB6B8C89089B6C9475A2C5828D5D162D26FEBA28D0665BF4E49328B21BEC63A765613D64A57D64CCB45F93CE5B4693E9B7F442E4D6BC79B862ECA5C02BFD58E57A306D6CDD0EB5AE364A59F7AA5CE8EA37B473A079CD764A8043D30F03C0B2863D5B4FCAB717B5CF1E94E839A95A365C7D2C37B744F5015E226377F4CC7A7A6422BB7DB5EB8E21771A9ECCB1BD2C5CFD5C9D9E35A958856A55ADE1EA99A3BA3759281B8DAF614FD055166C36685471D93C6E7BC9392EF9C732BB24B491D9251B4DE8530B1E96061C43434DA30BDEA21815785FF36B89ED3A5A1397B16502CF06AAFF36B8EEF9F219BFBBE97B60457673EB32C63BE6202BE48C3852BC4C140373A4D7FAFF13EEEF79562ED23229FA19A4CB84345EF79D46EC205627599572534BE5E474F0E3C74667287DFF15D386D1AFF4239905609EDB6AFF0F415EE0F72F9F5058161A1BD03558356F704C0ACF6556406CD4D70C7496CB9F3568481E965170728B0FC0D775F1F1A04B490250E952F3B5BDB775A3244B5DE96AB9AE1F6ADDFB5B411DD17D5E431D938E1E16F37EBF05B2FFDB49E3916EE7C5F4F56AD4FE96C96170F217BFA4BF7526A47135A224C89EE73312085066194AC20A9DE7F3CA4160FC0685132C0C995A53CB22CDD02F2841196670FD3928B0C794548799DBB2408093E9BB0C5BCEAC0CC9B278174431FEA7E7E9EC4535CAE226C8BFF939EEFD889E8AEAF418FBF3C173DF43EEB7E9C7B426F715AB8AD865923F4477287C0EE3A9FCE3ABFC7558448FA8AF37EBF22DE373402657A7AF4C0B24D5BE6D2B8AEAD30A46FABB346BB70DA029557F077888E235CDA1D2FEEEBC4FD93B0A6F566C2AB3CBDAF60E0732174112A2380E601EB9F082622C5C3BFD40F8C68EA75F20EEEB866AAEAB332E13B75523072E89E2036066D752CD67D5C0C868DDCAFF311DD349D756CD6DEB4C9AF86DDB396E2DFDED28B58CF2DB4E4B2EC9A41837C14CA395B87566F8D73796ED3E0C6FD8EE4744D53FB466D46EF9359A14FC71923346E6F1886F2846C337D4834D68EDF7BBA34857C1B5FACBA3D0A6EF4E91B530FE368B34DD97FD22242E437B3CDEE740C5625DB9BA1C5A0DA1F24F5C21CBE9747F986508EF336819461D812BD0E87754E18BD4E70C3D4669999B38346DA9F26F137E39F95E76A6077C02748DF23CB8D77DED8446A71BD87B22792591F643949F9EF6FD4CCB9F09026EC84C4687DDB6F9FE72E673D32071F480DB0CF0A641A15661A353BFAD19A5EA25F368956FF67276DB973DF90B35B971BC84D9EBDB1C3F0D8B465338780DBB43465B5F417E3C69EBDE1EAAF2AAB6B7B5087EC9D2727B8DC8B718B258E4874BD2A62B8A0ABD668C8D051D677EC3F1F32628E01A142FABCB9CD2F068B98E3911785ED61CF5BDDD0BD46741AAB52D7D85C28A8B36E07BEC93C1C472D2EBF34318976B7B7717B2EAC758E5BC4584EB05BB43438AAEC5B024EF9A0627BC021CA2F89E0793DFF0EC5F418C64FCDF606ACDDE824C125ECA19CA1F08AE1BE17C27319F70F0BA19612F3886196435FE7BE0F8759EA761E4F7A456A0FC62EAF6CCD439DB286ADE1AA341BD41CD38B3D306BF242C04F89B6E1FBC3423153422B3FE544385BF258CD5E2D55EEB5E90A9B7752F509EC696410CD8B2BCEDA2BDAD13CB2BE9571AD8931D349C72A2EC116586AE4E7FFAD32026B799AC910C3E442FB14B6F7C1DC53B9DF6DAAD4F7EADCDCEDA6B92AD6E070EC8CD755255A257EA4B550994275555FAA338C95932397222BEF0BA1907FC4308C8201A97D8E0C6915F640E76D50971974FE44C8FD473180A79CA1EF665E36705C643B2A3CD50BD1715D11A351BB7EC32C64B3B0A3FA769ECDF3313884F8337F502DB5B1F8892DCBE21A6168B7FB0D0745F70D27F9A1E826C7D1D6C07982886F2614D55C3FA759004F7289B728573AC8CBCE95130B35FBA6657E4CF1F7C7734F7F680505B6753FA06352AD74C5ADFD53919667AA57F35E501FD54E8F455BDAB676D4B7E636BAE82095941D49644FC26CE141963A57099AC67C08A633B0DCC1C0AB455DD42CCD5F9FC0F829CCD3D7412D9F5C0CC01DBC3F1D1D189D0095E0F28ABBDEC0B3C59784D4649212E9E2809A36D10C3F8E15E775AAF8BAE4FFEC95BB44509D918C0C4EF8599AE4F4E4198A477B6A0E065449D904BAEC1833AB19C415B1776C34241C4819EB80468EFDB0C2F138C5D11A61A216442DFCBCB29A8DA9AEA8C59815125BC29F81E07B74C6D060DACE4354F18485902555EFA01B202FCE15436AA1E736D073699007A753E0E62B4B9699AF986A5F032F34F85AB02CC21BC3739DA94BDF9C31B4406400868B2486C81089115842B796AFBF438E573A340B051E53E01310386A732218BE987CDED1AD037340A604A782A64E587A509505939615094B039F7AE9ACB401FEE2C0E873A9A91F11D2FF97983B4346D2F20D3D3B9F7A31C676D18127334408666E930A8E612626C3D0C683901578FA68FEC94693FE0F1987380E0B2346821CB14A2BE93E8AAA3ECD8042E53433EB0AD86B19B43904FA7C9EADD0B1B5AA71C428D1C5710C6BF2FC72538F659245E8C2933E0897D37463607EBB4B58712504408557DFCBB6E7C4120C773442F80E378D9F7133FDD547DBFA77E62A92710D484BA4FFE4F6B8462C5DA23C6BE5E93A62E11885B759122CF8B5C59DFC8D984F55FEC2A9EA6B432AA0981F024ABAC38C90235E728AA306391B0C8C7C70A69B970A4C2931E2551B983E014CC1104179ACC25384AC13303E1489B1E351248E109002AD8386403ECE02349B0813BED0EB9523C709994BE413C796BF18C86656BF11D0AA62D22EE55D07209BFD7068AC351ED9216373EACED05341AAEED0508FF2A3631B2E5E647CCABB633F19A620183BB179A046F69DFA37A1A4AE626F6379413763040366E38543B28B5FFEB658366EBE80EF4F96C22EF5623E9BE3C8C83A9EE1A42CD648B77123A44D4C929C24E3B4E78619E7D4AEA721D335235322565B2823C0CD662DCEF02F7EB076B3CCF3D0EC9EC034569F1F7EA785C547571C3002C88574BFA4299784D3128B8D96FDCB18C11E04CD2D792FA81122F6B2F8C8C072D53FEB90113E01B9FBDC6C043B2DF2DB6F9C304C69B991CD3B45A4C16E89C5349652F006D01DE41813AA947A7E06212D41D9C3FA7CE5552CDBB391D0996A6A33B9E012447517A8F4E051CE41CC63864D0A19DB74C20A374BCB0E31D7C755E1A7EA7C06FA0ACE32329B294902AAA2C3E2197F36B8E9A74CE5C5A00A2268B55B42C3B6F970B2703A4803F9612A318054ACC5318A55C4D064242F13AE4D5DD95A2320A5DD483991095BF2025459D0E9889D101CA0A7A6C30B799241337A4A0C9C5161988D66B4A46AAD5452002624947053DE1F40F449E2D71A320CD9C581BC87289AB024546EB72B4A87EA4AB8949379D51AD2535A39499A94A6744969BDA8D8E5BD582DA8327A35224754A65C10A032628F1B65DA990F48994FC6894A994AC7076AA422F1C65F2A4286B81969B54D8BB91A51251A7E8F1EC4B93F458D68D2290A6E5C1A4E926016D3E995C22F01434F581AD26098D1D2DCD8D5E74A09C3328F1BEC214EC8C41927C7BE048DF2BD2A4FACB90A72C1720676EBDCBB0F663CCB2135379B423639279BCC88A49DF194C5D99EE4E910ACA26AF831F2330B3831D30EF30E9C5084CE41876E142AF6D01081896FCA1978231FDC39FC08D091F365D7958F1CD1D46E6252FC93CD0AE5036F7C0CBA267B30D461654B7C3328B4A1A33AF1D191F35EF455C7C9CFC386E4D779BAE414ED2506CF578F860ECFE12E263AF0D9E635FB98857C11A04A48FD1568F4B19A5DD5F64CAB8EC01AD85393C582248CB986266C4F0A8626AD4AA13028D64E171C4423F3EE46A51D25A94AF63382C337EFB8058B31C1C3B500A9A95436F99DBD4381685EE1AAFC908C52162D352EC0E819943CB1D1A0F08D624865042C03A5707130EA155D4E18383E816A98D30983BA35E96B4F668DAC650B9EDBE55ED1EC903B354212E9AB351E3C88560AC41DC1F2124483F6C79E4908A752176A88718846821D871B3BB548CB729E8CFD4A171307D22617A9EB803425F865C65CC6CEA85692538BF421A43209A62A6A25C80D10496F104B02F2D96010414516E586091B5A556BB4FDADDB3B3C512D3DA04CD0F670B72FF2BDA166510570583F3F6C175B0DD46C97DBE7BB3F965B6DC062119C81F97F3D9D3264EF2F3F943516C5F2D1679453A3FDA74158AC374B308D6E9E2F4F8F8CF8B9393C5A6A6B10819B9F31FE0BB9E8A340BEE11F794C8708DDE45595EB47EF07C76B1DE489A311FF0155F15DBCEC46FF4E224B65F1ADB77C8FFEBF7ACCA396B3AD9C9F91D1EFA8684565477E92A9026BC8DDF5F86411C64FA42C917695C6E92FA51583F5AAD0924C5DB2874546B7CFE2DC8DF20942CB77154B0A4EB0B2F560F41BEBAC52D5679DD04DE415D3F992659C7624832F5179CDC84B01161FAB8D5C423028417BD75F784174D2700BC68DF56099E7A89C7CB3F317BC4BD70C04B5B151B8BA1AD862D4362819FDB90D5C742D23D6455CB558E6DD37AD77655D4E6CA6E30B25EF91B53007D87DD2BAB2410AF21D271F035C9833B24E3A356F2601E6AC5EDB1FF1BB24D06775F90D6D6BD0FA3D27433D863AAE47074C2DD55121116BEA0227BBEC2A62D7BC4B63B670947759B55461AADA2A6D56A23D938A83BBA0E9EA24DB9D176B4A9DBF4EB88E9E14D107E4BEFEEDA70495260858510D3D16DDD7AB5A19A5B76FCBA28D0665BE4B27E82EE998551C4CA915C289696052FAD4A6F16F533858CA6B5633277D8AF1173376056C64B62B42C97D97BA1CE0F4FEFB1F9109528CB33EA20C2735861C3D2FDC2AF885AAA2264AB9FFAD9FBE9403B2C60DDC03A32504504D84EBEF4B6709AE0BA6A80957CD3A2D26156362B5F3EE317379C95CA5779F3B3CD9EE301ADCB18511739B25B8EFAF12A27CFAD196DA9E30DBB86364AEC45D0526EED9CCA09EE3AE96C9CAD3BCCF774919689B031E33B09EB46F05E2E13E2B571E845ED8F36E0EBAE45E441473DD8279DA309E3F4A77A14C116300DA47C79EF2DE674B3AA0D3EF537AFCAB807D8CC6A5ED74C0B530D8D9F14D47D2CB29EEEFDC0CCC05E16DE1176570473BB41FCBBBD1D50D82D27732535532ED6E94BFA5B1709C66C83D2DFDA19B0DBA3DE65415E646548EE9A7B174431FE47D8A3D26D56775D238BA929B3FA0370FE4DBE8B0BEB06AB02B770DACC7D444F45B54BC43E52F0CCEFE712FCB4D9FAAEC973CB7DEFDBF4635A53FF8A17792CF1BBD25592B63D94A48DF5C47E88EE50F81CC6525F236E1FDAF972A44EC523127CB9A0F979925311F9B52534D96DD562D547E5C98A4BB2AB25EDD7417DB6833DEC7769D6BA71222CA2B6D5EA2ECD569D2FA782C67436958DEB1FD2ACEAB21E6096554F616CE3AAD98C997761D34D3817AE3CE48C6BA3E261536E20A19973A18A3E3FEF95C1E9E1590D022ADD35008CA66CDAAD7A8F8474A3DAE856846DF7B67B6DCEFE5F788AD728CF837B8ED0A6FDD182A127127720389C68F7F3E0DEEB447AB20D81B1D18E5739F9FFA7BBDF59A9C9BAA7DF3B684755BD86113CB98926D3A779D244D0EEB7EC49F2C845BAD992E3DE7513F1AC5043316EBA0ADBB6788F5235763C7615CFB01BF6EFABA8DE490FB42FD2641D118D34FB47109788894596F2ACB269FB8450B124D741E17459DE7687C3C2110FF5CC3EA4A38AECABE656C464D63C7644E51265587F8964F3EA777B9037F327125C374F7424055453883864545F12BD14859FD3343E44604FA5800F724135F2D1075DD552E911BAE379D952001569A2FAE16A8B9FDAAE5E8AF0212FE05ADC2F6BF765ED4EBA76652BACA676D08BEB21C8D698CCCBF27A595E3E965703A7EB2009EE51E6D95272D4FBF9BBDA1E242C9327AB4DA095BC5447342447D512BD0EA2843CDC318E45A83282AE4AC84847FFA950AE999A8F844E0A8ABBFC883901268FDCA85E25615CAE852F80CD8F7B862543B6BE571CD135235D31A4A57158F89968DE4DC994BE7C17AAA8A7FD646BDF564EC7802973152BB288A72663EE963C7708796A13AC84B4B92EB56AA2F439365555FFDD585291CED3676209659B183B92C66BF816AC2C6E274ADCE9DB72E5D9023FCB56F7C5B4F47D0C45B96B18E02BB696F99DE375957F2CE3F87C7E17C4FCB9255C547C26B50B822595C23C0489EE8801F20CE473AAAC35E6611A3B11FB06A2B29C199C69686CAA47A0F5C39890B4CF37E97474F34BF77797B4DF24CC3399FC9588487A67259ABC49DEE733E8EB26F31916C463B426D9F375C2C6116940F07A1147882408B40DF0A62CBA437971937E43C9F9FCF4F8E4743E7B1D47415E575C686A03BCE2ABE6838A059CFC488A05A0F566C1BF6E5F728050C9F3752C29384016A868ECB942017F47022AC43B0B0C0EC1D982A772C60156205017342F93E8D71245D5FEFCAE4A6E24282439161D12175ABA8A0CFC9AFA2DF9AF25C1DA81A8DF4F1E832CC4FBDDDF6D82A7DF1B28D10E84762694E9EAB0993064AB99674220E06926D8E4765680F3D975F0F40125F7C5C3F9FCA7636BDAE6B476D520844B2DAE92357A3A9FFF6745F9D5ECEADF5726E23FCC3E655821BC9A1DCFFE8BE6BCBA11C38D71E1484A23AE93D39F3DF5CA64C18FD2239DF8EEB743B03E010080A3D567BE079E583F80F7826C4D067ECD5A94D82B5F4DB6BD3B5140467D4D3C4341EC487D977AE1CEA7903C0F25656B7A1CCD8EDCBB9437352535495E53642E810C5ADF15D1D8C43A20385AAFC421ACBAACF3DDA2F9013BCD5FABEE5ECD6EF09261171168CE65B2A2A67D28D64F3CB0DECD574FC4CBF5E450233F958D5CAD94A19308F3A8E08332D9A29E5AC09F06E8BF3C2D85DD0B2E151656D2E0C85597ACAF5FE03DB1A208CCACC783271D91BF4F071A9074D97FCE5018E5D5CEF5DFAC9D805D81036AC73508EFD2856BBD5994D44E1044AF12885D17BBD483813AE0CA27F8DD7029EB27B82BFBAE7482FBDE9CA998A01B3039ABB1A4AD38E4EAA1CAA514E12EB78D3E97D64398C0B11BCB59B3B38CD66E97373BABF8D2029F19FD892B44D830383BC8CFCB2C2A9DB66127D82B7F279E9C67AF4C9D3A9D5DECB2F83C1B2D177B0BE1D9C1CA828EB3E854ACE67020FDADFBA5FA56F50B4A504692D43F93CD7F965467ECDBB22026CE523CCA4A11EED6565118C29DA0B414843B3965E507AFF34825CCFAF58FA8F4D91E9F1AF6E7344F593BA207630A9ABD8ED3E5F527FA1CFECB28F6323DDAE2157ED1AD0900F0E1B70A6487715ED58529F6CF4F02DA686F60329E135898659B39D1548E804F0A202E05323316E876F012F773DE4D152AFAA8652DE93EDA992A78E1D7DAEEB719D7FBCD40E4B01391AF28A2BA43BABDF5BE1D87DD52EC7B30D9D5EB3004728046B9ABD8E181DAA05B0BB08A97459BC114BB3246DBACCC01FEAEAD791C779F0648BBF2BABE243522FCC61340BF46F419849042669E7B60C489983FE6573A4C5A9786F4E94F7FB2163C9BD1E53B184791F8E6B71B492EB767F973396A83C4D218FD15F3573E4BADABCDEB82296173168E2C86539F6363D6DF62AFFD4F078CA71730178C1F5A9F68309656CFB380268D0DEA5D5A424999DEF502A3C385111803CAAC2F2F31DDF2202D73FA96C758707FB19B36B1E4ECE07A1CC1332969D65B07150CA835CF86F555572EAAE3FCA55734B67CF17748620BD88447869885F3F9F1D1D189305EE9D5980C45E67796E21F0472186528ABFD950BBC172CB22012D3F43E6758A746DB20968C856BEB08FA45D705FFE42DDAE2FD29C9BF1447EDA9EFAE0B6E499964C364DF18D1D2840BB417E8E64AA450A105DCB4763FB3B30A00890C200381431519A1981F5528846330840B96A6E2731CDCADDEAB2E176161C243C412657690F587B55E936787151FB01E6BD677B98E550180F7EAAB481497BCF313493DB0B552DDAB750A1F90AE3F88E80A7ADB7FD9B2450D3B7A0807E03B05C60793FECB614F241960C474CCD1649F01007A9858325C48E0C6C004189224C438B92C16BA6702BD339D6F21DF46AA6E2972D4678731B471D06D2808A20128FBD19F0329F7F090C06FBA49C3317A6158B4DA154299025AAADB36A68218F3BACCBFD3D2FFEEE0268A03E4F0595E8D3289CD2643F3BC75B0C1D644B89AD6DF7343F51E82479E2B33DC99D79496EF804EBF26F6E5C687625BF96AE41310D3D9DAF7A2AFEC9CAC7DD353FC458CA31ABB9743323B9F09782BE62828928698ACA8CAAB4A24358FE9E96E7F82A3471EE122D2145A0C8225654D3D8BB0462BF8400B405B47558C841EE1D6241A39EADAC7C3A0880E6E11E9314FBF27F4E8CB3EEF2B729A7AFC2498A1410E5D45FA053A7B091D40FCD774368BC68FE4A6C117CBB527966B4F40C4B8CFBE5C9D3D3ED71E1D21D68EF91E20827CF65A1936D9E660139EF94F497DFFE68C5CAC4C72222E823C0CC4DB2AAACACB9A9EC78F861A3142A5F717C7B131A228CADB2BC871EFC2E1ACE215FFA92F353C24224CFD8E078D2AAAF64B55DE76898AB7BBE2B6E3D99889426BA7B03056F83457859E1C382F20991A2453A3810A505F69EE12EA179EAFC3069D254293637EFFEE62F3F5F729ED476CFE257B1D460718EEEA0A0128CD1D2922C0E6B35DCA880C34F52518B581AD2B3B26A4E2F54D9D82428B408227B65746B308BD324FF5BDD2C61EDAABBA47606F39A427792F901E20D4BB8FC9B24EBA87C6BEDA0F9BA03EA93DA9AC57FAD62863BFBBA20D909ED9A05859E76C0B73FF21D51EC40217A521E3816B6266822B5F6164A335EE42E7ED037D97B52D8376239C54297A15DA419868D2EE37D4B59A30AE98C35705474C1B1037017DC06C6284B17C020BCC537DE774C22012FB652F443224EBCDA8D6A21655E7F5A95D876ED8DCEF826553F891D4FBCCEFFC21073B4C9808840C34F9F0F5896A3CEB9C4A6D39EF7E360F5C36683F0366529FE4835567478947562C9BA6A1D909C66D80DA2C1FF980E189419A53577648D403BD48B818072095BEA211EC9C412E7CFB818522B3D22D11F69977B1D42BCD2C0ED92192DB3AEE2F3EB7619B2EEC94CAC026A89F1F98D4F16907C73DDC471129E3CC21A28205A90F27324950BA05350F0BAB8E9506AC2C4950B57F0DE32E580FA2E8EC9D59188AC0599FFEC6588B498C38358D5F1A99EA1F0B262FA6EF7085184AD3B8F5419707EC8398830225A2B18C24949E6B53436A7FD28844BB6DA588082D7A0B081EF726119463D09C37814976D41401E6696F415984794924E51A247690A282463581979E2120EAA01720A387D53A49D6CCB7104634CD5D788AFAF0478C5EE97B1830EC3987104DA11F9AEA535EBF33A9F1876C8A12309CEE41E30BFCC07B9C233EFE1BB84104073D5CF5475EC9A8815F84BD1EEC4A8EBCABF799DFC162684BD3759F2EBB67678BFAC4BCF901FF59A459708FAED3358AF3EAD7B3C51772DFCBA62E6A7786111FDDEF489C619A09AAE2EA7644DB3657C95DDA7EBAE5386A9B7035F8AE5111902F8BAFB322BA0BC2023F0E519E47C9FD7CF68F202E71934B6CC6D657C9A7B2D896C405C0662D7EA68541BEFCEAFA3F5B083C9F7DAACA1DE73E8680D98C4829E64FC99B12BB951DDFEF2495231524C827E5A60C3699CB8294C3BE7FEE287D4C1320A1467CDD97F01BB4D9C69858FE295906A48ABE3D6F5F73F401DD07E133FEFD315A93DC4C1511F344B0623F7B1B05F759B0C91B1ABBF7F19F18C3EBCDD35FFE0FDCDB99BF42700100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201712222045341_V7.1.0_MaxParallelism', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5DDD72DB3A92BEDFAA7D0795AE66A6CE58B64F9DD933297BA612C739E34C9CB82C676AEF543405D99C50A40E49F9D8BBB54FB617FB48FB0A0BF04FF84703044929EBABC422D068343EA01B4077E37FFFFB7FCEFEFABC8E274F28CBA334399F9E1C1D4F272809D365943C9C4FB7C5EA8F3F4FFFFA977FFD97B3CBE5FA79F28FA6DC8FA41CAE99E4E7D3C7A2D8BC99CDF2F011AD83FC681D85599AA7ABE2284CD7B36099CE4E8F8FFF3C3B3999214C628A694D2667B7DBA488D6A8FC03FF79912621DA14DB20BE4E9728CEEBDFF197794975F23958A37C1384E87C7ADDD27FFB1FDB0C1DCD7F8DDF0745701FE4E8E8637A9F1F5D62D2C54B49683A791B4701E6718EE2D5741224495A0405EEC19BAF399A17599A3CCC37F88720BE7BD9205C6E15C439AA7BF666571CDAC9E353D2C9D9AE62432ADCE645BAB62478F2632DB5195FDD49F6D356AA58AE959048AF4BD99E4F2FD2356E604944399DF0EDBDB9883352D64EFA4714CD1F2636357F6891767CF4F3D1F1D1F10F938B6D5CE06AE709DA1659804BDC6CEFE328FC3B7AB94BBFA1E43CD9C631DD43DC47FC8DF901FF7493A51B94152FB76825F6FB6A399DCC5812339E464B415EBD12D22FDB08FFFF33E628B88F518BAA9996D23CCCA24DF1B7207F875032DFC451D1907B97A6310A126B8A77E8B9A581C18E67F474721D3C7F42C943F1888732789E4E3E44CF68D9FC5253FD9A447801C0958A6C8BCCAD7E0E9EA28712265CFB7854E705DA5490BA457159267F8C36D57C3CA2BE2F18F87DC8D2F56D1AB324E8228BBB207B40A473A9BEDC3CDD66A105CBD520BC0B0A3CA17229D30C75B6F48E6D65A196A1867175C9A68B34EB67B3DDBCD5CE6646F49E663345736F6733C5A3CB6CE6AA7798CDF5B8120ACDD4534EC49F8EBDCC438E835B946321CF51F11EE5459494235F618AEF9A3D9D8B0C2D5142F42629A3E9DAC9E9CFA0BEE959F89AE4C10AC918A9CC839199B823A332080F1A6D63A838EC80B9E0EC2A89087FB7A8C85EAE9202654FD81ACC1B0AF8971F4FADE700EE58B4DEAEBDD26488BD0BC26FE96A758D311161958DB256B458B0B1CBA4C5C4DF16055A6F8A8E7C9285EC0EDBD8E9B6F020C69B002FD3318AA37CCDD182AA5646C3FBB50678A56AB21A2C0D18B921507F5C30AA56E095FEACB25A9832B6168B7A99374A5957552E74750DED1868AAD90E09B06BFA6E0058D6B0676B84F936C0F6D9F8128D2E55C99AABCFDBF53D5935019548DF1D8DBA8EC69CC86ED78579C7903B0D4F9ADC5E16AE26B26E9D352DB18AA5553587CB6F8ECBBD4943D9ACF81AF684B5CA82CD1A8D2A2EEBCF4D2B39C725FF59A697843232BD64B312FA5C050F6B051C62851A672D788F6254E02DD1AF5BACD7D192589B0D13783450F5B7C1EACFE72FB86E6B54BA9E75918DE0721BE3CD76901572461C295E268A8E39D26BB60E231E0DF0AC5CA4DBA4E8A6902E135278D97518B181581E82958B9B5A2A27A7BD9F5CD66B86D2F65F306598F595FE24D300CC77DBD5FF539017B8FEE5330AB7854607B40516750D8E49E1BB4C0B8885BAAA815673F9D30635C9C3520A4E66F101D8BA2E361E742A49002A9D6ABEB6F7B6669464AA2B4D2DD7F943CD7B7F33A825BACF73A865D2D1C262EA779B20FBBF9D349E06B7564C57AB466D6F990C06277BF136FDAD5521B5A9112541F6329D101F826D96A1242CD1793E2D0D04C66E5018C14297A939352FD20CFD8212946106973741812DA6A43CCCDC6C0B0438D45E65587366DB904C8B0F4114E37F3A9EC65E94BD2CEE82FC9B9F93E2CFE8B9280F9EB13D1FBC743D2C7E9F7E4E2B725FF15211BB0CF2A76885C297301ECB3EBECADF8645F484BA5AB32ED7203701195CDD7A659A20A9B6B6AD28CA5B198CF40F69D66C1B4043AABE07788CE225CDA152FFEEAC4F591D85352B1695E9656D798703998B2009511C07308B5CA8A0E80B574EDF11BEB0E3E91788FBAAA09AEBF28CCBC46D59C8814BB2F00130B32BA9E6B32C6064B42AE5FF988E69A42DABE6B631264DFC36E51CB796FE76945A46F96DA7259764508C9B60A6D042DC3A33FCEB0BCB761F861AB6FB1171E9EF7B65D46EF9352B29F872925346E6FE883514BDE10BEAC12694F67BEF28D25570ADBE7914CA74DD29B21AC6DF6691A6FBBA5F84B874688FC7BB1CA858CC2B579343BB42A8EC1357C8726BBA3FCC3284F719B40CA38EC01568743BAAF045EA26434F51BACD4D1C9AB654F9B7116F4EBE979DE9019F005DA33C0F1E74B79D50C776037BCF242425D25E44F96969DFCFB4FCA920E086CCA474D86D9BEF9B339F9B0689A107DC6680370D8A6515D63B756D4D2F5595CCBD55D6EC64EC36953DD90B15B961AC84C9DBFB1C7F0D8B7AA570B01A76878CB6B682FC78D2D6BC3DD4C5ABDCDE5622F8254BB79B6B44EE62C864911F2E498B2E282AF49C311616D638730DC7EB4D90C335C85F561774A5E1D1721E7322F03CAD39EA7BBB17A8CE8254735B5A85C28ACB6AC0B7D825F889E5A4D3F543186F97F6E62E64D60F31CB798D085F17EC0E0D29BA16DD92D435754EA802ECA258CF83CAAF79F6BF400CA4FCDF616AF5DE820C129ECA19CA1F09AE6BE17C273E9F70F0BA29612F3886296435FE3BE0F86D9EA761E4F7A456A0FCAAEAF64CD539EB286ADC6AA541D5A0469CD969832B0913015ED3EDC24BD353614564E69FAAABF05A425F2DAA769AF7824CBDCD7B81F238BA0CA2C0E6DBFBD6DBDB3A26BD947EB9027BD28386534E943DA1CCD0D4E94F7FEA45E5D6833590C287AC4BECD41B7E8DE28D4EFBD5AD4B7CADCDCEDA6B90AD6E070E88CD755AAA44ABD4D75225501E75A9D21FC549CE92C99113B18597753FE017212085689C62BD2B477E9239E85527C45D3E93333D920AA22FE4295BD8978D9F15180F498FD65DF59E8F44ABD46CCCB2CB184FED28BC49D3D8BF6526101F076FEA09B6B7361025B97D434C2516FF60A1E9BEE2A4FB303D06D9F23AD8F430500CE5C31AAA9AF5EB20091E5036E60CE7581978D3A36066BFD69A5D7E407FF0DDD1DCDB03426D8A4E690DAA57AE91B4BE137B32CC740AFFAA330BFA49EEE92B7B57C7B498FCC6D69C40133283A82D897827CE241963A570992C27C08C63BB159839146812C28598ABF3E91F04399B5B6825B26B811903B685E3A3A313A1113C1F505659D91778B0F09C8C92429C3C5112469B2086F1C355779AAFB3B64DFECB7BB44109D918C0C4EF8599B64D6E813049EF6C46C1CB883A21965C830775603983B6D6ED86858288033D7109D03E36115E2618BB224CD543C8807E94A753509535E519B302A34A7863F03D0C6E99DC0C1A58C9739E3090B204AA3CF5036406F8C3A9AC571DC6DA0E6C3201746A7C18C46863D334E30D0BE165C69F725705A843786B72B4295BF38737880C8010D04491D80211222B0857F2D0F6F171CAC7468160A38A7D0262060C4F654016D30E1BDBD5A36D6814C098F054C8CA0F4B23A0B234C2A0286163EE5D572E037DB8B1D81FEA68468637BCE4E70DD2D4B49D804C0FE7DEF77298B96108CCD100191AA5C3A09A0B88B1B530A0E9045C2D9A2EB25386FD80FB638E0182CBD2B00A598610751D44D735CA8E4DE03435C403DBAE30766308B2E93451BD7BA143AB9043A892E312C2F8B7E5B800C72E93C48B32653A3CB2EDC6C8E6608DB6E650028A0821AB8F7FD38D4F08E4788EE805701C2FFB7EE2A71BAAEFF7D44F4CF504829A90F7C9FF698D90AC587BC4D8D56AD2E4250271AB4E52E479922BF31B39ABB0EE935DC5D3985A463520109E6499154799A0E6184515662C021679FF58212C178E5478D0A3C42BB7179C823982E04213B90447297864201C69C3A30602293C0040051B8768801D7C24013670A3DD21568A072E13D2D78B256F2D9EC1B06C2DBE43C1B485C7BD0A5A2EEEF75A477138AA5DC2E28687B5BD8006C3B5BD00E1B76223235BAE7EC4B86A3B15AF4916D0BB79A109F096B63DA8A5A1646E647B433960070364E38643B58352DBBF5E3668B6866E4FD7672359B71A4977E561184CB5CF106A065B7C93D0C1A34E4E1176DA71C20BF3EC4B52A5EB9890AC9129499315E461B014FD7E67B85D3F58E379EE704866EF284A8BBF53C3C3A2AAF51B0660417C5AD217CAC4678A41CECD7EFD8E658C0047927E96D40F9478597B6164386899E2CF0D9800BFF8ECD5071E12FD6EB1CDEFC731DECCE490AAD562B040E79C4A2A7B01680BF0F60AD4512D3A0517A3A0EEE0EC3975AC926ADCCDE148B0301DDDF10C20388A5AF7E850C05ECE618C5D061DDA798B04324AC70B3BDEC157C5A5E13A05AE81B2968FA4C85242AA28A3F88458CEAF39AAC339736902888A2C5EA265D179BB5838192005FCB194988551A0C47C8551CAD564202414D52155774F8ACA28B45E0F664254FC829414753A6026463B282BE8B1CEDC66928CDF908226E75B64205ACD2919A9662D021110533A2AE809A77F20F26C8A1B0569E6C4DA40960B5C152832AB2E478B6A473A9B9870D309555A92334A1999AA344664B1A96DEFB8592D2C7BF060548AA46E5199B1C280094A7C6D572A247D2025DF1B6528252B9CDD52A1178E32785294B540CB4D2AECDBC85289A843F478F6A5417A2CEB461148C3F260D2749380369E4C2E1178089AFAC0561384C6F696E6462F3A50CC19947857610A7AC62049BE3CB0A71F156152DD65C853960B9053B7DE6558D93166D989A13CDA9E31C13C5E64C584EFF4B65C99DE4E910ACA26AE83EF2330B283ED306F30E9C5080CE4E877E2429F6D01081816FCA1978231FCC39FC08D011F364D7998F1F51B46E6292F893CD0CE5036F6C0CBA467A30D061654BBC3328B4AEA33AFED19EF35EF455CBC9FFC30664DFB9AAE414E52576C757F7867ECEE12E27DAF0D966357B9884FC11A04A4F7D156F74BE9A5DD5D644ABFEC1EB585D93D5822484B9F62A6C770AF62AAD7AA13028D64E17EC4423B3EE46A91D25A94AFA33B2CD37F7B8758B31C1C1B500A9A95436799DBE4381685EEEAAFC908C5C163D352EC0E8E997DCB1DEA0F085E490CAE848079AE7626EC635551BB0FF6B2B648758441DD19D76549698FAA6D8825B7D9B7AACD23B96396CAC54573366AECB9E08CD58BF923B804E9BB2DF71C52B12EF80E751083E02D043B6E76978AF13505FD993AD40FA68B274CC7137780EB4B9FB38C194DBD30AD04E7574843084493CC54940BD09BC0D29F0076D362E9404011E5BA051659936AB5BDD26EBF9DCDE698D63AA87F389B91F75FD1A6D806719930386F3E5C079B4D943CE4BB9AF52F93F926084947FE389F4E9ED771929F4F1F8B62F36636CB4BD2F9D1BACD501CA6EB59B04C67A7C7C77F9E9D9CCCD6158D59C8C89DBF806F5B2AD22C7840DC5722C325FA106579D1D8C1D3C9C5722D29C65CE02B6E159BC6C43B7A71109B9BC6A60EF97F55CF2A9DB3A6919D9C3FE0AEAF896B45F996AE0269426D5C7F1E067190E913255FA4F1769D549FC2EAD362492029BE46A1A35AE1F36F41FE0EA164BE89A382255D3D78B1780CF2C53D2EB1C8AB22F006AAFCC934C9CA174312A93FE3E426B88D08C3C7CD261E1120BCE8B5BB27BC681A01E0455B5B2578AA128F977F62F68879E18097262B361643930D5B86C4027FB721ABF785A45BC8CA928B1CEBA6E5AEECA2A8D4955D6764ADF22FA600DA0EDB2A8B24109F21D271F035C9831592F1512DF2601EAA85DB63FB77649B0C6EBE20A5AD5BEF6749D38D6087A192C3D1097757494458B84545F67285555BF6847577CE128EAA328B8C145A4475A9C55AB2715037741D3C47EBED5ADBD0BA2AD3AD21A6857741F82D5DAD1A77499260858510D3D07D557AB1A68A5B36FCB628D07A53E4B27682F69B8552C48B2379502CDD16BCB4CA75B3A8BED90FC64D9005718CE2285F0B83B0D8D01FF74D3DCAAC6CBFBAD15D2F5AE944892EB49CBD1F85F4413CBDA7FA7E2B51667DD4218FE7B0849CA55587AB888B5F49C876D9EB66468C07DA7E01EB06D681812A22C076F0A58F90D304976501AC3BEA12E5D268A50AF3F90BAEC82D8751BEC8EB9F6DB6328F68B98D11F53E24BB93A93E2F72F2DD9AD186FA652211434B1B25F622682837EA53655BB78DB4AAD3D6CAE65BBA48B789B0DFE31B09AB42F0562E13620C72E845CD8F36E06B5F5BE441477DD8A73547E31DEA6FE951F870C0562065E5BDD798E38DAAD6A7D5DFB82ADD296023ABA9AE191626C91A3F28A8BD83B21EEEFDC04CCF5616DE68B62F0F739B4CFCBBBD1E50E82D27752555532EDAE936FDAD7530637657E96FCD08D86D7D57599017D936244FD87D08A218FF236C7DE9328B555BC86268B65975AF9C7F936F0EC3AAC0A2C0259CF6889FD173516E3EB18D14BCF0DBC4047FAD77D44BF2DD72ABF83EFD9C56D4BFE2491E4BECAE7491A44D0B5B52C67A603F452B14BE84B1D4D6889B8F76B61C497FF184045B2EA87F1EE5B045FE1A0A4D765396587459F264392BD9D992766BA03A32C216F687346BCC38111651536AB14AB3456BCBA9A0319E4E65C305FA54ABBA600A9866D553185AB96A3663E65DD87803CE7941F739E25A677BD8901B4868C65C48CECF8F7BA9703A5856BD804AF7BA00B352D6E5169D7B429A516D744BC2B67BDBBD5667FF2F2CC56B94E7C1034768DDFC68C1D0337167100C4EB4FBB977EB75A475B2F1ACB1591DAF72F2FF2FABDF592D93554BBF77581D55692006B0E4461A4C9FEA49E398BBDFB227312917E97A438E7B97B523B562198A71D145D894C57B94B2B0E3B1AB78865DB3FF503A0B8F7AA07D9126CB88AC48937F04F116312ECE529E553A6D9F102A66FA3A289CCEB7F7EDE1B070C4437DB3F714291D06CBB1153199D59F1D513947195EBF44B279F9BB3DC8EBF113092EEB2F3A9202AA29441C32AA2FC9BA148537691A1F22B0C75A800F7242D5F2D1FB725552E9E011E479DA52001569A2EAE36283BFDACE5E8AF0214FE04ADCAF73F775EE8E3A776533ACA276D093EB31C89698CCEBF47A9D5E3EA6570DA7EB20091E50E6595372D4BBD9BBDA16242C932F8B75A095BC748DA8490EBA4A743A8812C27B873816A1B213BA2E42463AFAAB42F9CA545F123A2D50DC9B4ACC0930F9E446F52A09E3ED52B801AC7FDC332C19920078C5119D8AD215435A1A87859F91C6DD14A3E9CB76A17285DA0FB6B6B672387A8CC42B5991793CD58178F7E4BB83CB5313B72544E3B5115B2345E5B111B0FA7B6349A23B4FD7C412CA363E76243AD87017ACCC99274ADCE96EB9B46C81D7B2E533340D7D1F5D51EE1A7AB8C5D632BF33BCAEF2CFDB383E9FAE82983FB7848B8A0FD07641B02401990727D11D31409C817C4C9529CC3C0C632B62DF4054664983330DF54DF508B46E18137201F045DA35BAFEA5FDBBCD0550C7E13309024A1191A8D15234799D13800FCCAF8A4C2758104FD19204E557011B47A400C1EB451C211220D014C09BB26885F2E22EFD8692F3E9E9F1C9E974F2368E82BC4AE450A71C78C327E307E52038F991E42040CBF58CAF6E9FC98050C9F3652CC9634026A8A8ECB9FC037F47022AC4A7100C06C1D98CA772C601562050E549DF26D1AF5B1495FBF3551933495048622C5A24CEB4741581FD15F57BF25F4B82950151D54F9E822CC4FBDDDFAD83E7DF1B28D1068476249451F0B0913044AB99474220E06924D898795680D3C975F0FC09250FC5E3F9F4A7636BDAE66879552784B732AE92257A3E9FFE6749F9CDE4EADF1726E23F4CBE6478417833399EFC17CD79F9D0861BE3C29194465C27A73F7B6A9509AE1FA4453A9EDE6F83E0F50400008E5697F1EE7960FD00DE0BB23581FD156B5162BFF86A82F8DD890202F52BE2190A6247EABBD00B773E8598FC4E7264E3F0A5A4C461B655628E0A4C6EA7CA8B9AC2A324D514315020D5D8756ED5DAB5722D8E960BB10B8B367E7D37FD7EC0E6F7D7B2B937933B3C2AEC74040DB94C56D4A8F7C5FA8907D6DBF1EA3877E42B6E5F3D3F95F55CBDBC430711669BC13B65D26A1D4D597F2B40F7E96929EC4E7029B1B090BA592EDAB07FFD04EF8815858B67D51F3CE888FC7DDA5387A4D3FE26436194977BE07FB3362776A912A8BD5B2FBC4B27AEF5B65392854110BD4A20764DEC82187A6A804BC4E077EBA6CCC4E0BED8B74918DC77F94CEE055D87C9A98F256DC5715987A55C4A116EBCDBACE7D2CC0A23187643196B769AD1DAECF2A667157736F091D19FDD42840D83B383FCBC8CA2D268EB7780BDF277E2C978F6CAD4A9D329C82E1ED0B3D272D1B7109E1DB42CE8608C0EEAAA8F19D2DFDA5FCA5BAF5F50823212EE7E438E11B2A43CADDF6C0BA2E22CC5A3CC39E1AE6D152926DC094A934AB89353E690F03A8E54E8AD5FFB880AC4ED7069B13FE782CA2C141D1853D0EC74302FCF64D1E51A4146B193EAD1A6C1F08B6E8D2B810FBB5520DB8FF1AA4E71B17F761250477B0393F19CC0422DDB8C892607057C50001E2E9091B140B78395B89FE36ECA75D16559D692EEB23A53A933FC6ADBFD56E37ABB19881C7620F20545547748B7B7D6B763B71B8A5D0F26DBCC1F069710502F77B93F3C50EB756B015EE2657E6BB0855DE9ED6D5ECC01F6AEAD7A1C769F0608E0F23ABF24D926FC7A26406F23BA74420846338F3DD077458C44F32B1D26404C43FAF4A73F590B9E8D0DF3EDD6A308A1F3DB8C242ADCB3FCB968B75EBC728CF68AF996CF72D5D54688C11661733C8FCC1B541FAD635EBFC556BB9F0E184F2F602618DFB52E7E652CAD8E670175401CD4BAB484923250EC1546870B23300694F1635EBCC3E54E5AE640308F5EE5FEBC406DBCD2D9CE7538826782DBACB70E2A1850739E75EB2BDF8454470C48DF906CF8E21FB9C41AB076B40C310BE7D3E3A3A313A1BFD2B73B198ACCEF2CC53F08E430CA5056D92B17782F5864412406FCDD64784D8D36412CE90B57D611F4B3B609FECB7BB4C1FB5312C929F6DA53DB6D13DC9432C98689E331A2A57617685EF8CD9548A15C0BB8616D7F664715001219407A0287CA3342313E2A5708476708172C8DC5E730B85B7C543D53C2C284878825CAEC20EB0F6B9D06CF0E2B3E603DD4A8EFA226CB54021FD58F9A285EA1E70792FA60ABA5DAAA55302090AE3F88E85283DBDF6CD9A286ED3D8403F0EB04C383497F73D811490618310D7334D96F00801E26960C4F1BB8313002862401314E268BC5DA33C2BA339E6D21DF46AADE3B725CCF0EA36BC3A0DB905A440350F6D29F0329F7F190C06F7A93C3D17BA15FB4DAA55419035AAA773BC68218535D66DF69E97F777013C50132F82C1F5919456793AE79DE3AD8606B245C8D6BEFB9A17A0FC1238F95E9EFCC6B4CCD7740A75F23DB72C343B1C9A135F00988E96CED7B59AFEC8CAC7D5BA7F8271D075576AF8764763613F07DCD41502475315950395C9548AA3FD3C3DDFC04478FDCC345A42994E8054BCAEC7C166E8D56F081A692B6F6AA18083DC2FB4B3472D45994FB4111EDDC22D263BE7E4FE8D12790DE57E4D499FD8933438D1C3A1FF52B74F6123A00FFAFF174168D1FC99B85AF9A6B4F34D79E8088319F7D993A7B7CAE3D3842AC0DF33D4004B9F65A1836D96667139EF92F49F592E7843CD14C62222E823C0CC4772FCA1CCE9A9687F7861AD043A5F38DE3D01851A4F7EDE4E4B877EE7056FE8AFFD4272DEE1311A676878346E9557B5B26CA9DA3E2FD2E4DEE703A6624D7DA31348C153ECDF9A54707CE2B48C606C9D868A01CD4179A5789BAB9E7EBB0414789D0E498DFBF3BDF7CFDCB4CFBE19B7FC93EACD102867B0443004AFDDA8A08B0E964173222034DF59C46A560ABCC8E09C99D7D5785A0D02290E0896D955959845699AFFA5669650F6D55DD22B0B51CD292BC15480B10EAED65B2AC91F6A3B1ADE66213D426B52795B54ABF3F656C7797B401D232EB142B6B9C2D616E3FA4CA8358E0BC34643C7045CC4C70E92B8C6C34CA5D68BCF9A06FB2D265D06684932A45AB4239081375D8FD9A7AA013C61573F8AAE0882903E226A00F984D8C309A4F6081F9AA6F9C0E184462BBECD34A8660BD09555A5C45D5717D6AD3A1ED36F7BBA0D9147624559FF99D3FE460BB091381108126EFBE3E508D679D5B521BCEDB9FCD1D9775DA4F8799D0277967D5D151E29115CBA6A96B768271EBA036CA47DE61786090E6D495ED12F5412F12CEC70148A5AB68043D67900B5FBE67A1C8B4744384FDE65D2CD54C338B437688E4368FBB8BCFADDBA6A73FA532B071EAE73B26357C9ACE711FF751444A3F7388A8604EEAFD894CE2946E41CDC3C4AA7CA501334BE254ED7F857117AC0751B4FACE2C0C85E3AC4F7B63A8C9247A9C9AFA2FF54CF58F059315D3B5BB820FA5A9DF7AA7CB03B641CC4E8112D1587A124ACFB5A92E353F6944A2DDB6524484129D0504F77B9308CAD169CE9BC0243B6A8A00F3B5B3A02CDCBC24927275123B485141BD9AC053CFE01075D013905987D56B92AC986F210CA89A5BF714F5E18FE8BDD2F530A0DF730EC19B42DF35D5555EB733A9E1BB6CF212309CEE41FD0BFCC07B98233EFE0EDC208283EEAEFA9257D26BE08DB0D7835DC99177599FF91D2C8626355D7B75D97E3B9B5527E6F50FF8CF22CD8207749D2E519C97BF9ECD6EC97B2FEB2AA9DD19467CF4B02371866926A8F4ABDB116DCA5C25ABB4B9BAE5386A8A7039F8AE5111909BC5B75911AD82B0C09F4394E751F2309DFC2388B7B8C8255663CBABE4CBB6D86C890980D55AFC420B83DCFCEADA3F9B093C9F7D29D31DE73EBA80D98C482AE62FC9BB2D362B5BBE3F4832472A48902BE53A0D3619CB82A4C37E7869297D4E1320A15A7CED4DF81D5A6F624C2CFF92CC039245DF9EB7AF39FA841E82F005FFFE142D496CA68A88792058B19FBD8F82872C58E7358D5D7DFC27C6F072FDFC97FF0301FD6E191E710100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201801042318445_V7.2.0_MaxParallelismPerPool', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5DDD72DB3A92BEDFAA7D0795AE66A6CE58B64F9DD933297BA612C739E34C9CB82C676AEF543405D99C50A40E49F9D8BBB54FB617FB48FB0A0BF04FF84703044929EBABC422D068343EA01B4077E37FFFFB7FCEFEFABC8E274F28CBA334399F9E1C1D4F272809D365943C9C4FB7C5EA8F3F4FFFFA977FFD97B3CBE5FA79F28FA6DC8FA41CAE99E4E7D3C7A2D8BC99CDF2F011AD83FC681D85599AA7ABE2284CD7B36099CE4E8F8FFF3C3B3999214C628A694D2667B7DBA488D6A8FC03FF79912621DA14DB20BE4E9728CEEBDFF197794975F23958A37C1384E87C7ADDD27FFB1FDB0C1DCD7F8DDF0745701FE4E8E8637A9F1F5D62D2C54B49683A791B4701E6718EE2D5741224495A0405EEC19BAF399A17599A3CCC37F88720BE7BD9205C6E15C439AA7BF666571CDAC9E353D2C9D9AE62432ADCE645BAB62478F2632DB5195FDD49F6D356AA58AE959048AF4BD99E4F2FD2356E604944399DF0EDBDB9883352D64EFA4714CD1F2636357F6891767CF4F3D1F1D1F10F938B6D5CE06AE709DA1659804BDC6CEFE328FC3B7AB94BBFA1E43CD9C631DD43DC47FC8DF901FF7493A51B94152FB76825F6FB6A399DCC5812339E464B415EBD12D22FDB08FFFF33E628B88F518BAA9996D23CCCA24DF1B7207F875032DFC451D1907B97A6310A126B8A77E8B9A581C18E67F474721D3C7F42C943F1888732789E4E3E44CF68D9FC5253FD9A447801C0958A6C8BCCAD7E0E9EA28712265CFB7854E705DA5490BA457159267F8C36D57C3CA2BE2F18F87DC8D2F56D1AB324E8228BBB207B40A473A9BEDC3CDD66A105CBD520BC0B0A3CA17229D30C75B6F48E6D65A196A1867175C9A68B34EB67B3DDBCD5CE6646F49E663345736F6733C5A3CB6CE6AA7798CDF5B8120ACDD4534EC49F8EBDCC438E835B946321CF51F11EE5459494235F618AEF9A3D9D8B0C2D5142F42629A3E9DAC9E9CFA0BEE959F89AE4C10AC918A9CC839199B823A332080F1A6D63A838EC80B9E0EC2A89087FB7A8C85EAE9202654FD81ACC1B0AF8971F4FADE700EE58B4DEAEBDD26488BD0BC26FE96A758D311161958DB256B458B0B1CBA4C5C4DF16055A6F8A8E7C9285EC0EDBD8E9B6F020C69B002FD3318AA37CCDD182AA5646C3FBB50678A56AB21A2C0D18B921507F5C30AA56E095FEACB25A9832B6168B7A99374A5957552E74750DED1868AAD90E09B06BFA6E0058D6B0676B84F936C0F6D9F8128D2E55C99AABCFDBF53D5935019548DF1D8DBA8EC69CC86ED78579C7903B0D4F9ADC5E16AE26B26E9D352DB18AA5553587CB6F8ECBBD4943D9ACF81AF684B5CA82CD1A8D2A2EEBCF4D2B39C725FF59A697843232BD64B312FA5C050F6B051C62851A672D788F6254E02DD1AF5BACD7D192589B0D13783450F5B7C1EACFE72FB86E6B54BA9E75918DE0721BE3CD76901572461C295E268A8E39D26BB60E231E0DF0AC5CA4DBA4E8A6902E135278D97518B181581E82958B9B5A2A27A7BD9F5CD66B86D2F65F306598F595FE24D300CC77DBD5FF539017B8FEE5330AB7854607B40516750D8E49E1BB4C0B8885BAAA815673F9D30635C9C3520A4E66F101D8BA2E361E742A49002A9D6ABEB6F7B6669464AA2B4D2DD7F943CD7B7F33A825BACF73A865D2D1C262EA779B20FBBF9D349E06B7564C57AB466D6F990C06277BF136FDAD5521B5A9112541F6329D101F826D96A1242CD1793E2D0D04C66E5018C14297A939352FD20CFD8212946106973741812DA6A43CCCDC6C0B0438D45E65587366DB904C8B0F4114E37F3A9EC65E94BD2CEE82FC9B9F93E2CFE8B9280F9EB13D1FBC743D2C7E9F7E4E2B725FF15211BB0CF2A76885C297301ECB3EBECADF8645F484BA5AB32ED7203701195CDD7A659A20A9B6B6AD28CA5B198CF40F69D66C1B4043AABE07788CE225CDA152FFEEAC4F591D85352B1695E9656D798703998B2009511C07308B5CA8A0E80B574EDF11BEB0E3E91788FBAAA09AEBF28CCBC46D59C8814BB2F00130B32BA9E6B32C6064B42AE5FF988E69A42DABE6B631264DFC36E51CB796FE76945A46F96DA7259764508C9B60A6D042DC3A33FCEB0BCB761F861AB6FB1171E9EF7B65D46EF9352B29F872925346E6FE883514BDE10BEAC12694F67BEF28D25570ADBE7914CA74DD29B21AC6DF6691A6FBBA5F84B874688FC7BB1CA858CC2B579343BB42A8EC1357C8726BBA3FCC3284F719B40CA38EC01568743BAAF045EA26434F51BACD4D1C9AB654F9B7116F4EBE979DE9019F005DA33C0F1E74B79D50C776037BCF242425D25E44F96969DFCFB4FCA920E086CCA474D86D9BEF9B339F9B0689A107DC6680370D8A6515D63B756D4D2F5595CCBD55D6EC64EC36953DD90B15B961AC84C9DBFB1C7F0D8B7AA570B01A76878CB6B682FC78D2D6BC3DD4C5ABDCDE5622F8254BB79B6B44EE62C864911F2E498B2E282AF49C311616D638730DC7EB4D90C335C85F561774A5E1D1721E7322F03CAD39EA7BBB17A8CE8254735B5A85C28ACB6AC0B7D825F889E5A4D3F543186F97F6E62E64D60F31CB798D085F17EC0E0D29BA16DD92D435754EA802ECA258CF83CAAF79F6BF400CA4FCDF616AF5DE820C129ECA19CA1F09AE6BE17C273E9F70F0BA29612F3886296435FE3BE0F86D9EA761E4F7A456A0FCAAEAF64CD539EB286ADC6AA541D5A0469CD969832B0913015ED3EDC24BD353614564E69FAAABF05A425F2DAA769AF7824CBDCD7B81F238BA0CA2C0E6DBFBD6DBDB3A26BD947EB9027BD28386534E943DA1CCD0D4E94F7FEA45E5D683358EC2BF8C83BC88C21B6C7AF72369C83AC84EF5E1D744DEC8B55F4DBBC4F3DAECE4BD06F5EA76FC805860A7A551B4827D2D8D02E5519746FDD19FE4EC9A1C7111DB7B59F7037EF10252C0C629D6BB32E62799831E7742DCE533394324A927FA429EB2857DD9685A81F190F476DD55EFF94FB44AD4C60CA4D4AB7F4B50203E0EDED4136C6F6D2EFF568F37C45462F10F169AEE2B4EBA0FD363902DAF834D0F03C5503EACA1AA59BF0E92E0016563CE708E957137590D33FBB5D6ECF211FA83EF8EE6DE1E486A53824A6B50BD728DDCF59D489461A653B8599DC9D04F32515FD9C23AA6E1E437B6E6849D9019446D49C43B7826A9192B85CB6439016638DBADC0CCA14093802EC45C9D4FFF20C8D9DC422B915D0BCC18B02D1C1F1D9D088DE0F980B2CACABEC08385E7649414E2E4899230DA04318C1FAEBAD37C9DB56DF25FDEA30D4AC8C600267E2FCCB46D720B84497A67330A5E46D409B1EB1A3CA803D919B4B56E3E2C14441CE8894B80F6B1892833C1D81561AA1E4206F4A33C7D83AAAC29AF99151855C21B83EF6170CBE482D0C04A9E638581942550E5A9262033C01F4E65BDEA30D676609309A053E3C320461B0BA7196F58C83033FE947B2C401DC25B93A34DD99A3FBC4164008480266AC51688105941B89287D28F8F533E160B041B55AC15103360782A03C09876D858B21E6D43A300C684A742567E581A0195A5110645091BE3EFBA7219E8C38DC5FE50473332BCE1253F6F90A6C2ED04647A38F7BE97C3CC0D43209006C8D0A82006D55C008EAD85014D5FE06AD174919D32CC08DC1F73CC115C968655C83264A9EB20BAAE51766C02A7A921FED87685B11B43904DA78922DE0B1D5A853842951C9780C6BF2DC705547699245E9429D3E1916D374636076BB43587125044085984FC9B6E7C0222C773442F80E378D9F7133FDD507DBFA77E626A2910D4843C53FE4F6B84E4C8DA23C6AE5693260F12885B755224CF935C994FC95985759FEC2A9EC6D432AA0181F024CBE438CA0435C744AA30631120C9FBC70A61C070A4C2832C255EB9BDE014CC1104179A4829384AC12303E1481B8E351048E101002AD8384403ECE02309E8811BED0EB1593C709910C25E2C796BF10C86656BF11D0AA62D3CEE55D07271BFD73A8AC351ED1286373CACED053418AEED0508BF151B19D972F523C671DBA9784D7282DECD0B4D40B9B4ED412D0D257323DB1BCA013B18201B371CAA1D94DAFEF5B241B335747BBA3E1BC9BAD548BA2B0FC360AA7DF65033D8E21B880E1E75728AB0D38E135E98675F922A3DC88464A94C495AAE200F83A5E8F73BC3EDFAC11ACF738743327B47515AFC9D1A1E1655ADDF30000BE25396BE50263E8B0C726EF6EB772C63043892F433A87EA0C4CBDA0B23C341CB147F6EC004F88569AF3EF090E8778B6D7E3F8EF166268754AD1683053AE75452D90B405B80B757A08E6AD129B81805750767CFA9639554E36E0E478285E9E88E6700C151D4BA478702F6720E63EC32E8D0CE5B2490513A5ED8F10EBE2A2E0DD729700D94B57C24459612524519C527C4727ECD511DCE994B13405464F1122D8BCEDBC5C2C90029E08FA5C42C8C0225E62B8C52AE260321A1A80EA9BA7BC25446A1F57A3013A2E217A4A4A8D3013331DA4159418F75E6369364FC86143439DF2203D16A4EC948356B118880984252414F38FD03916753DC28483327D606B25CE0AA40915975395A543BD2D9C4849B4EA8D2929C51CAC854A531228B4D6D7BC7CD6A61D98307A35224758BCA8C15064C50E2EBBE5221E90329F9DE28432959E1EC960ABD7094C193A2AC055A6E5261DF62964A441DA2C7B32F0DD26359378A401A960793A69B04B4F1647289C043D0D407B69A2034B6B734377AD18162CEA0C4BB0A53D0330649F2E5813DFDA80893EA2E439EB25C809CBAF52EC3CA8E31CB4E0CE5D1F68C09E6F1222B267CA7B7E5CAF4568B545036711D7C1F81911D6C877983492F46602047BF1317FA4C0C40C0B0E00FBD148CE11FFE046E0CF8B069CAC38CAFDF4C324F7949E4817686B2B1075E263D1B6D30B0A0DA1D965954529F796DCF78AF792FE2E2FDE487316BDAD77B0D7292BA62ABFBC33B63779710EF7B6DB01CBBCA457C7AD62020BD8FB6BA5F4A2FEDEE2253FA65F7A82DCCEEC112415AFA14333D867B1553BD569D1068240BF72316DAF121578B94D6A27C1DDD6199FEDB3BC49AE5E0D88052D0AC1C3ACBDC26C7B12874577F4D46280E1E9B96627770CCEC5BEE507F40F04A62702504CC73B533611FAB8ADA7DB097B545AA230CEACEB82E4B4A7B546D432CB9CDBE556D1EC91DB3542E2E9AB35163CF0567AC5ECC1FC12548DF6DB9E7908A75C177A88318046F21D871B3BB548CAF29E8CFD4A17E305D3C613A9EB8035C5FFA9C65CC68EA85692538BF421A42209A64A6A25C80DE0496FE04B09B164B07028A28D72DB0C89A54ABED9576FBED6C36C7B4D641FDC3D98CBC378B36C53688CB84C179F3E13AD86CA2E421DFD5AC7F99CC3741483AF2C7F974F2BC8E93FC7CFA58149B37B3595E92CE8FD66D86E2305DCF82653A3B3D3EFEF3ECE464B6AE68CC4246EEFC057CDB529166C103E2BE12192ED18728CB8BC60E9E4E2E966B4931E6025F71ABD83426DED18B83D8DC343675C8FFAB7A56E99C358DECE4FC01777D4D5C2BCAB77B1548136AE3FAF33088834C9F28F9228DB7EBA4FA14569F164B0249F1350A1DD50A9F7F0BF2770825F34D1C152CE9EAC18BC563902FEE7189455E15813750E54FA64956BE189248FD192737C16D44183E6E36F18800E145AFDD3DE145D308002FDADA2AC1539578BCFC13B347CC0B07BC3459B1B1189A6CD8322416F8BB0D59BD2F24DD4256965CE458372D77651745A5AEEC3A236B957F3105D076D856592481F80C918E83AF491EAC908C8F6A9107F3502DDC1EDBBF23DB6470F305296DDD7A3F4B9A6E043B0C951C8E4EB8BB4A22C2C22D2AB2972BACDAB227ACBB73967054955964A4D022AA4B2DD6928D83BAA1EBE0395A6FD7DA86D655996E0D312DBC0BC26FE96AD5B84B92042B2C849886EEABD28B3555DCB2E1B74581D69B2297B513B4DF2C94225E1CC98362E9B6E0A555AE9B45F5CD7E306E822C88631447F95A1884C586FEB86FEA516665FBD58DEE7AD14A274A74A1E5ECFD28A40FE2E93DD5F75B8932EBA30E793C8725E42CAD3A5C455CFC4A42B6CB5E3733623CD0F60B5837B00E0C541101B6832F7DF49C26B82C0B60DD51972897462B5598CF5F70456E398CF2455EFF6CB3957944CB6D8CA8F721D99D4CF5799193EFD68C36D42F1389185ADA28B1174143B9519F2ADBBA6DA4559DB65636DFD245BA4D84FD1EDF48581582B77299106390432F6A7EB4015FFBDA220F3AEAC33EAD391AEF507F4B8FC28703B602292BEFBDC61C6F54B53EADFEC655E94E011B594D75CDB03049D6F84141ED1D94F570EF07667AB6B2F046B37D7998DB64E2DFEDF580426F39A92BA99A72D14EB7E96FAD8319B3BB4A7F6B46C06EEBBBCA82BCC8B62179C2EE4310C5F81F61EB4B9759ACDA421643B3CDAA7BE5FC9B7C7318560516052EE1B447FC8C9E8B72F3896DA4E085DF2626F86BBDA35E92EF965BC5F7E9E7B4A2FE154FF2586277A58B246D5AD89232D603FB295AA1F0258CA5B646DC7CB4B3E548FA8B2724D87241FDF328872DF2D75068B29BB2C4A2CB9227CB59C9CE96B45B03D59111B6B03FA45963C689B0889A528B559A2D5A5B4E058DF1742A1B2ED0A75AD50553C034AB9EC2D0CA55B31933EFC2C61B70CE0BBACF11D73ADBC386DC404233E642727E7EDC4B85D3C1B2EA0554BAD7059895B22EB7E8DC13D28C6AA35B12B6DDDBEEB53AFB7F61295EA33C0F1E3842EBE6470B869E893B836070A2DDCFBD5BAF23AD938D678DCDEA789593FF7F59FDCE6A99AC5AFABDC3EAA84A0331802537D260FA544F1AC7DCFD963D8949B948D71B72DCBBAC1DA915CB508C8B2EC2A62CDEA394851D8F5DC533EC9AFD87D25978D403ED8B34594664459AFC2388B788717196F2ACD269FB845031D3D741E174BEBD6F0F8785231EEA9BBDA748E930588EAD88C9ACFEEC88CA39CAF0FA2592CDCBDFED415E8F9F4870597FB1267949267514DEA4A9C4A902551F171BFC554759982F14D60E79BE50C239C42933D6D27E9053B5968FDE4BAC924A075F23CF0B426FB397227CC813B812F7EBDC7D9DBBA3CE5DD90CABA81DF4E47A0CB22526F33ABD5EA7978FE955C3E93A4882079479D6941CF51E2CE9A60509CBE4CB621D68252F5D236A9283AE129D8EB884C0E1210E5CA8BC87AE8B90918EFE1252BE32D5D78F4E0B14F75A1373B64C3EB951BD4AC278BB14EE16EB1FF70C4B86F4025E714427B974C59096C661E167A47137457FFAB25DA82CA4F683ADADAD1C8E1E63FC4A5664BE547588DF3DF9EEE04CD5448409717E6D2CD848F17E6C6CADFE465A9242CFD305B484B28DF71E893B36DC322BB3F1891277BAB52E2D5BE0856FF9C04D43DF475794BB861EEEC7B5CCEF0CAFABFCF3368ECFA7AB20E6CF2DE1A2E243BF5D102C496DE6C1FD74470C10C1201F536572340FC3D88AD8371095F9D7E04C43BD5E3D02AD1BC6842C037C91768DAE7F69FF6EB30CD411FE4CEA815244241EB5144D5E671BE043FEAB22D30916C453B424E1FE5528C8112940F07A114788841E3405F0A62C5AA1BCB84BBFA1E47C7A7A7C723A9DBC8DA320AF5244D4C90CDEF069FE41D90D4E7E24D90DD0723DE3ABDBE7482054F27C194B322490092A2A7B2EB3C1DF91800AF1910583417036E3A99C718015085419D8B749F4EB1645E5FE7C554663121492E88D1689332D5D45CA808AFA3DF9AF25C1CA80A8EA274F4116E2FDEEEFD6C1F3EF0D946803423B12CAF87AD84818E2E0CC232110F034126C343E2BC0E9E43A78FE849287E2F17CFAD3B1356D731CBEAA13C22B1C57C9123D9F4FFFB3A4FC6672F5EF0B13F11F265F32BC20BC991C4FFE8BE6BC7CC2C38D71E1484A23AE93D39F3DB5CA84ED0FD2221DA9EFB741F07A02000047ABCB78F73CB07E00EF05D99A9401156B5162BFF86AD203B81305A400A8886728881DA9EF823ADCF914A2FD3BC9918DF097921287D95689392A30B99D2A2F6A0ABC9254534457815463D7B9556BD7CA69395A2EC42E2CDAC8F8DDF4FB019BDF5FCBE6DE4CEEF0A8B0D31134E4325951A3DE17EB271E586FC7ABE3DC91AFB87DF5FC54D673F5F20E1D44986D06EF9449AB753465FDAD00DDA7A7A5B03BC1A5C4C242EAC0B968130AE8277847AC289C47ABFEE04147E4EFD39E3A249DF637190AA3BCDC03FF9BB539B14BC240EDDD7AE15D3A71ADB79D92FC0E82E85502B16B62171ED153035C8A07BF5B37658E07F7C5BE4DEFE0BECB67B23AE83A4C4E7D2C692B8ECB3A2CE5528A70E3DD663D97E66C18C1B01BCA58B3D38CD66697373DABB8B3818F8CFEEC16226C189C1DE4E7651495465BBF03EC95BF134FC6B357A64E9D4E417691869E95968BBE85F0ECA06541076374B8587DCC90FED6FE52DE7AFD8212949140FA1B728C9025E569FD665B101567291E65360B776DAB485EE14E509AAEC29D9C323B85D771A4827AFDDA4754886F874B8BFD391754E6B7E8C0988266A78379798E8C2ED708328A9D548F36C1865F746B5C097CD8AD02D97E8C5775F28CFDB393803ADA1B988CE704166AD9664C34D92DE08302F070818C8C05BA1DACC4FD1C7753168D2ECBB2967497D5994ACAE157DBEEB71AD7DBCD40E4B003912F28A2BA43BABDB5BE1DBBDD50EC7A30D9E61431B884807AB9CB2AE2815AAF5B0BF0122FF35B832DEC4A6F6FF3620EB0776DD5E3B0FB34400097D7F925C963E1D733017A1BD1A51342309A79EC81BE2B62249A5FE93001621AD2A73FFDC95AF06C6C985FBE25E1DABEFD8614317A9EE5CF45BBF5E29563B457CCB77C96ABAE36420CB6089BE37964DEA0FA681DF3FA2DB6DAFD74C0787A0133C1F8AE75F12B6369753C0BA803E2A0D6A52594948162AF303A5C188131A08C1FF3E21D2E77D232078279F42AF7E7056AE395CE76AEC3113C13DC66BD7550C1809AF3AC5B5FF9DAA43A6240FA3A65C317FF7C26D680B5A3658859389F1E1F1D9D08FD95BE0ACA50647E6729FE4120875186B2CA9CB8C07BC1220B2231E0EF26C36B6AB40962495FB8B28EA09FB54DF05FDEA30DDE9F92484EB1D79EDA6E9BE0A69449364C1C8F112DB5BB40F37670AE440AE55AC00D6BFB333BAA0090C800D21338549E118AF151B942383A43B860692C3E87C1DDE2A3EA011416263C442C516607597F58EB34787658F101EBA1467D173559A612F8A87E2E45F1BE3D3F90D4075B2DD556AD82018174FD41449774DCFE66CB16356CEF211C80DF3D181E4CFA9BC38E4832C0886998A3C97E0300F430B1647834C18D8111302409887132592CD69E11D69DF16C0BF93652F59292E37A76185D1B06DD86D4221A80B297FE1C48B98F87047ED36B1F8EDE0BFDA2D52EA5CA18D052BD083216C498EA32FB4E4BFFBB839B280E90C167F97CCB283A9B74CDF3D6C1065B23E16A5C7BCF0DD57B081E79AC4C7F675E636ABE033AFD1AD9961B1E8A4D0EAD814F404C676BDFCB7A656764EDDB3AC53F1639A8B27B3D24B3B399802F770E8222A98BC982CAE1AA4452FD991EEEE627387AE41E2E224DA1442F585266E7B3706BB4820F3495B4B557C540E8115E76A291A3CEA2DC0F8A68E716911EF3F57B428F3E81F4BE22A7CEEC4F9C196AE4D0F9A85FA1B397D001F87F8DA7B368FC485E437CD55C7BA2B9F604448CF9ECCBD4D9E373EDC111626D98EF0122C8B5D7C2B0C9363B9BF0CC7F49AA374227E4F16712137111E46120BE7B51E670D6B43CBC37D4801E2A9D6F1C87C68822BD6F2727C7BD7387B3F257FCA73E69719F8830B53B1C344AAFDADB3251EE1C15EF77697287D33123B9D68EA161ACF069CE2F3D3A705E41323648C64603E5A0BED0BC4AD4CD3D5F870D3A4A8426C7FCFEDDF9E6EB5F66DA0FDFFC4BF6618D1630DC23180250EAD75644804D27BB90111968AAE7342A055B65764C48EEECBB2A04851681044F6CABCCCA22B4CA7CD5B74A2B7B68ABEA1681ADE59096E4AD405A80506F2F93658DB41F8D6D35179BA036A93DA9AC55FAFD2963BBBBA40D909659A75859E36C0973FB21551EC402E7A521E3812B6266824B5F6164A351EE42E3CD077D93952E8336239C54295A15CA4198A8C3EED7D4039D30AE98C35705474C191037017DC06C6284D17C020BCC577DE374C02012DB659F563204EB4DA8D2E22AAA8EEB539B0E6DB7B9DF05CDA6B023A9FACCEFFC2107DB4D980884083479F7F5816A3CEBDC92DA70DEFE6CEEB8ACD37E3ACC843EC93BAB8E8E128FAC58364D5DB3138C5B07B5513EF20EC3038334A7AE6C97A80F7A91703E0E402A5D4523E839835CF8F23D0B45A6A51B22EC37EF62A9669A591CB24324B779DC5D7C6EDD363DFD2995818D533FDF31A9E1D3748EFBB88F2252FA994344057352EF4F6412A7740B6A1E2656E52B0D985912A76AFF2B8CBB603D88A2D5776661281C677DDA1B434D26D1E3D4D47FA967AA7F2C98AC98AEDD157C284DFDD63B5D1EB00D62760A9488C6D293507AAE4D75A9F9492312EDB695222294E82C20B8DF9B44508E4E73DE0426D951530498AF9D0565E1E6259194AB93D8418A0AEAD5049E7A0687A8839E80CC3AAC5E9364C57C0B6140D5DCBAA7A80F7F44EF95AE8701FD9E7308DE14FAAEA9AEF2BA9D490DDF65939780E1740FEA5FE007DEC31CF1F177E006111C7477D597BC925E036F84BD1EEC4A8EBCCBFACCEF603134A9E9DAABCBF6DBD9AC3A31AF7FC07F1669163CA0EB7489E2BCFCF56C764BDE7B595749EDCE30E2A3871D89334C3341A55FDD8E6853E62A59A5CDD52DC7515384CBC1778D8A80DC2CBECD8A68158405FE1CA23C8F9287E9E41F41BCC5452EB11A5B5E255FB6C5664B4C00ACD6E2175A18E4E657D7FED94CE0F9EC4B99EE38F7D105CC664452317F49DE6DB159D9F2FD4192395241825C29D769B0C95816241DF6C34B4BE9739A0009D5E26B6FC2EFD07A136362F997641E902CFAF6BC7DCDD127F410842FF8F7A7684962335544CC03C18AFDEC7D143C64C13AAF69ECEAE33F318697EBE7BFFC1F00106DEAE8710100, N'6.1.3-40302')
INSERT [jobs_internal].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'201806011732598_V7.2.1_MaxParallelismPerPool', N'ElasticDatabaseJob', 0x1F8B0800000000000400ED5DDD72DB3A92BEDFAA7D0795AE66A6CE58B64F9DD933297BA612C739E34C9CB82C676AEF543405D99C50A40E49F9D8BBB54FB617FB48FB0A0BF04FF84703044929EBABC422D068343EA01B4077E37FFFFB7FCEFEFABC8E274F28CBA334399F9E1C1D4F272809D365943C9C4FB7C5EA8F3F4FFFFA977FFD97B3CBE5FA79F28FA6DC8FA41CAE99E4E7D3C7A2D8BC99CDF2F011AD83FC681D85599AA7ABE2284CD7B36099CE4E8F8FFF3C3B3999214C628A694D2667B7DBA488D6A8FC03FF79912621DA14DB20BE4E9728CEEBDFF197794975F23958A37C1384E87C7ADDD27FFB1FDB0C1DCD7F8DDF0745701FE4E8E8637A9F1F5D62D2C54B49683A791B4701E6718EE2D5741224495A0405EEC19BAF399A17599A3CCC37F88720BE7BD9205C6E15C439AA7BF666571CDAC9E353D2C9D9AE62432ADCE645BAB62478F2632DB5195FDD49F6D356AA58AE959048AF4BD99E4F2FD2356E604944399DF0EDBDB9883352D64EFA4714CD1F2636357F6891767CF4F3D1F1D1F10F938B6D5CE06AE709DA1659804BDC6CEFE328FC3B7AB94BBFA1E43CD9C631DD43DC47FC8DF901FF7493A51B94152FB76825F6FB6A399DCC5812339E464B415EBD12D22FDB08FFFF33E628B88F518BAA9996D23CCCA24DF1B7207F875032DFC451D1907B97A6310A126B8A77E8B9A581C18E67F474721D3C7F42C943F1888732789E4E3E44CF68D9FC5253FD9A447801C0958A6C8BCCAD7E0E9EA28712265CFB7854E705DA5490BA457159267F8C36D57C3CA2BE2F18F87DC8D2F56D1AB324E8228BBB207B40A473A9BEDC3CDD66A105CBD520BC0B0A3CA17229D30C75B6F48E6D65A196A1867175C9A68B34EB67B3DDBCD5CE6646F49E663345736F6733C5A3CB6CE6AA7798CDF5B8120ACDD4534EC49F8EBDCC438E835B946321CF51F11EE5459494235F618AEF9A3D9D8B0C2D5142F42629A3E9DAC9E9CFA0BEE959F89AE4C10AC918A9CC839199B823A332080F1A6D63A838EC80B9E0EC2A89087FB7A8C85EAE9202654FD81ACC1B0AF8971F4FADE700EE58B4DEAEBDD26488BD0BC26FE96A758D311161958DB256B458B0B1CBA4C5C4DF16055A6F8A8E7C9285EC0EDBD8E9B6F020C69B002FD3318AA37CCDD182AA5646C3FBB50678A56AB21A2C0D18B921507F5C30AA56E095FEACB25A9832B6168B7A99374A5957552E74750DED1868AAD90E09B06BFA6E0058D6B0676B84F936C0F6D9F8128D2E55C99AABCFDBF53D5935019548DF1D8DBA8EC69CC86ED78579C7903B0D4F9ADC5E16AE26B26E9D352DB18AA5553587CB6F8ECBBD4943D9ACF81AF684B5CA82CD1A8D2A2EEBCF4D2B39C725FF59A697843232BD64B312FA5C050F6B051C62851A672D788F6254E02DD1AF5BACD7D192589B0D13783450F5B7C1EACFE72FB86E6B54BA9E75918DE0721BE3CD76901572461C295E268A8E39D26BB60E231E0DF0AC5CA4DBA4E8A6902E135278D97518B181581E82958B9B5A2A27A7BD9F5CD66B86D2F65F306598F595FE24D300CC77DBD5FF539017B8FEE5330AB7854607B40516750D8E49E1BB4C0B8885BAAA815673F9D30635C9C3520A4E66F101D8BA2E361E742A49002A9D6ABEB6F7B6669464AA2B4D2DD7F943CD7B7F33A825BACF73A865D2D1C262EA779B20FBBF9D349E06B7564C57AB466D6F990C06277BF136FDAD5521B5A9112541F6329D101F826D96A1242CD1793E2D0D04C66E5018C14297A939352FD20CFD8212946106973741812DA6A43CCCDC6C0B0438D45E65587366DB904C8B0F4114E37F3A9EC65E94BD2CEE82FC9B9F93E2CFE8B9280F9EB13D1FBC743D2C7E9F7E4E2B725FF15211BB0CF2A76885C297301ECB3EBECADF8645F484BA5AB32ED7203701195CDD7A659A20A9B6B6AD28CA5B198CF40F69D66C1B4043AABE07788CE225CDA152FFEEAC4F591D85352B1695E9656D798703998B2009511C07308B5CA8A0E80B574EDF11BEB0E3E91788FBAAA09AEBF28CCBC46D59C8814BB2F00130B32BA9E6B32C6064B42AE5FF988E69A42DABE6B631264DFC36E51CB796FE76945A46F96DA7259764508C9B60A6D042DC3A33FCEB0BCB761F861AB6FB1171E9EF7B65D46EF9352B29F872925346E6FE883514BDE10BEAC12694F67BEF28D25570ADBE7914CA74DD29B21AC6DF6691A6FBBA5F84B874688FC7BB1CA858CC2B579343BB42A8EC1357C8726BBA3FCC3284F719B40CA38EC01568743BAAF045EA26434F51BACD4D1C9AB654F9B7116F4EBE979DE9019F005DA33C0F1E74B79D50C776037BCF242425D25E44F96969DFCFB4FCA920E086CCA474D86D9BEF9B339F9B0689A107DC6680370D8A6515D63B756D4D2F5595CCBD55D6EC64EC36953DD90B15B961AC84C9DBFB1C7F0D8B7AA570B01A76878CB6B682FC78D2D6BC3DD4C5ABDCDE5622F8254BB79B6B44EE62C864911F2E498B2E282AF49C311616D638730DC7EB4D90C335C85F561774A5E1D1721E7322F03CAD39EA7BBB17A8CE8254735B5A85C28ACB6AC0B7D825F889E5A4D3F543186F97F6E62E64D60F31CB798D085F17EC0E0D29BA16DD92D435754EA802ECA258CF83CAAF79F6BF400CA4FCDF616AF5DE820C129ECA19CA1F09AE6BE17C273E9F70F0BA29612F3886296435FE3BE0F86D9EA761E4F7A456A0FCAAEAF64CD539EB286ADC6AA541D5A0469CD969832B0913015ED3EDC24BD353614564E69FAAABF05A425F2DAA769AF7824CBDCD7B81F238BA0CA2C0E6DBFBD6DBDB3A26BD947EB9027BD28386534E943DA1CCD0D4E94F7FEA45E5D683358EC2BF8C83BC88C21B6C7AF72369C83AC84EF5E1D744DEC8B55F4DBBC4F3DAECE4BD06F5EA76FC805860A7A551B4827D2D8D02E5519746FDD19FE4EC9A1C7111DB7B59F7037EF10252C0C629D6BB32E62799831E7742DCE533394324A927FA429EB2857DD9685A81F190F476DD55EFF94FB44AD4C60CA4D4AB7F4B50203E0EDED4136C6F6D2EFF568F37C45462F10F169AEE2B4EBA0FD363902DAF834D0F03C5503EACA1AA59BF0E92E0016563CE708E957137590D33FBB5D6ECF211FA83EF8EE6DE1E486A53824A6B50BD728DDCF59D489461A653B8599DC9D04F32515FD9C23AA6E1E437B6E6849D9019446D49C43B7826A9192B85CB6439016638DBADC0CCA14093802EC45C9D4FFF20C8D9DC422B915D0BCC18B02D1C1F1D9D088DE0F980B2CACABEC08385E7649414E2E4899230DA04318C1FAEBAD37C9DB56DF25FDEA30D4AC8C600267E2FCCB46D720B84497A67330A5E46D409B1EB1A3CA803D919B4B56E3E2C14441CE8894B80F6B1892833C1D81561AA1E4206F4A33C7D83AAAC29AF99151855C21B83EF6170CBE482D0C04A9E638581942550E5A9262033C01F4E65BDEA30D676609309A053E3C320461B0BA7196F58C83033FE947B2C401DC25B93A34DD99A3FBC4164008480266AC51688105941B89287D28F8F533E160B041B55AC15103360782A03C09876D858B21E6D43A300C684A742567E581A0195A5110645091BE3EFBA7219E8C38DC5FE50473332BCE1253F6F90A6C2ED04647A38F7BE97C3CC0D43209006C8D0A82006D55C008EAD85014D5FE06AD174919D32CC08DC1F73CC115C968655C83264A9EB20BAAE51766C02A7A921FED87685B11B43904DA78922DE0B1D5A853842951C9780C6BF2DC705547699245E9429D3E1916D374636076BB43587125044085984FC9B6E7C0222C773442F80E378D9F7133FDD507DBFA77E626A2910D4843C53FE4F6B84E4C8DA23C6AE5693260F12885B755224CF935C994FC95985759FEC2A9EC6D432AA0181F024CBE438CA0435C744AA30631120C9FBC70A61C070A4C2832C255EB9BDE014CC1104179A4829384AC12303E1481B8E351048E101002AD8384403ECE02309E8811BED0EB1593C709910C25E2C796BF10C86656BF11D0AA62D3CEE55D07271BFD73A8AC351ED1286373CACED053418AEED0508BF151B19D972F523C671DBA9784D7282DECD0B4D40B9B4ED412D0D257323DB1BCA013B18201B371CAA1D94DAFEF5B241B335747BBA3E1BC9BAD548BA2B0FC360AA7DF65033D8E21B880E1E75728AB0D38E135E98675F922A3DC88464A94C495AAE200F83A5E8F73BC3EDFAC11ACF738743327B47515AFC9D1A1E1655ADDF30000BE25396BE50263E8B0C726EF6EB772C63043892F433A87EA0C4CBDA0B23C341CB147F6EC004F88569AF3EF090E8778B6D7E3F8EF166268754AD1683053AE75452D90B405B80B757A08E6AD129B81805750767CFA9639554E36E0E478285E9E88E6700C151D4BA478702F6720E63EC32E8D0CE5B2490513A5ED8F10EBE2A2E0DD729700D94B57C24459612524519C527C4727ECD511DCE994B13405464F1122D8BCEDBC5C2C90029E08FA5C42C8C0225E62B8C52AE260321A1A80EA9BA7BC25446A1F57A3013A2E217A4A4A8D3013331DA4159418F75E6369364FC86143439DF2203D16A4EC948356B118880984252414F38FD03916753DC28483327D606B25CE0AA40915975395A543BD2D9C4849B4EA8D2929C51CAC854A531228B4D6D7BC7CD6A61D98307A35224758BCA8C15064C50E2EBBE5221E90329F9DE28432959E1EC960ABD7094C193A2AC055A6E5261DF62964A441DA2C7B32F0DD26359378A401A960793A69B04B4F1647289C043D0D407B69A2034B6B734377AD18162CEA0C4BB0A53D0330649F2E5813DFDA80893EA2E439EB25C809CBAF52EC3CA8E31CB4E0CE5D1F68C09E6F1222B267CA7B7E5CAF4568B545036711D7C1F81911D6C877983492F46602047BF1317FA4C0C40C0B0E00FBD148CE11FFE046E0CF8B069CAC38CAFDF4C324F7949E4817686B2B1075E263D1B6D30B0A0DA1D965954529F796DCF78AF792FE2E2FDE487316BDAD77B0D7292BA62ABFBC33B63779710EF7B6DB01CBBCA457C7AD62020BD8FB6BA5F4A2FEDEE2253FA65F7A82DCCEEC112415AFA14333D867B1553BD569D1068240BF72316DAF121578B94D6A27C1DDD6199FEDB3BC49AE5E0D88052D0AC1C3ACBDC26C7B12874577F4D46280E1E9B96627770CCEC5BEE507F40F04A62702504CC73B533611FAB8ADA7DB097B545AA230CEACEB82E4B4A7B546D432CB9CDBE556D1EC91DB3542E2E9AB35163CF0567AC5ECC1FC12548DF6DB9E7908A75C177A88318046F21D871B3BB548CAF29E8CFD4A17E305D3C613A9EB8035C5FFA9C65CC68EA85692538BF421A42209A64A6A25C80DE0496FE04B09B164B07028A28D72DB0C89A54ABED9576FBED6C36C7B4D641FDC3D98CBC378B36C53688CB84C179F3E13AD86CA2E421DFD5AC7F99CC3741483AF2C7F974F2BC8E93FC7CFA58149B37B3595E92CE8FD66D86E2305DCF82653A3B3D3EFEF3ECE464B6AE68CC4246EEFC057CDB529166C103E2BE12192ED18728CB8BC60E9E4E2E966B4931E6025F71ABD83426DED18B83D8DC343675C8FFAB7A56E99C358DECE4FC01777D4D5C2BCAB77B1548136AE3FAF33088834C9F28F9228DB7EBA4FA14569F164B0249F1350A1DD50A9F7F0BF2770825F34D1C152CE9EAC18BC563902FEE7189455E15813750E54FA64956BE189248FD192737C16D44183E6E36F18800E145AFDD3DE145D308002FDADA2AC1539578BCFC13B347CC0B07BC3459B1B1189A6CD8322416F8BB0D59BD2F24DD4256965CE458372D77651745A5AEEC3A236B957F3105D076D856592481F80C918E83AF491EAC908C8F6A9107F3502DDC1EDBBF23DB6470F305296DDD7A3F4B9A6E043B0C951C8E4EB8BB4A22C2C22D2AB2972BACDAB227ACBB73967054955964A4D022AA4B2DD6928D83BAA1EBE0395A6FD7DA86D655996E0D312DBC0BC26FE96AD5B84B92042B2C849886EEABD28B3555DCB2E1B74581D69B2297B513B4DF2C94225E1CC98362E9B6E0A555AE9B45F5CD7E306E822C88631447F95A1884C586FEB86FEA516665FBD58DEE7AD14A274A74A1E5ECFD28A40FE2E93DD5F75B8932EBA30E793C8725E42CAD3A5C455CFC4A42B6CB5E3733623CD0F60B5837B00E0C541101B6832F7DF49C26B82C0B60DD51972897462B5598CF5F70456E398CF2455EFF6CB3957944CB6D8CA8F721D99D4CF5799193EFD68C36D42F1389185ADA28B1174143B9519F2ADBBA6DA4559DB65636DFD245BA4D84FD1EDF48581582B77299106390432F6A7EB4015FFBDA220F3AEAC33EAD391AEF507F4B8FC28703B602292BEFBDC61C6F54B53EADFEC655E94E011B594D75CDB03049D6F84141ED1D94F570EF07667AB6B2F046B37D7998DB64E2DFEDF580426F39A92BA99A72D14EB7E96FAD8319B3BB4A7F6B46C06EEBBBCA82BCC8B62179C2EE4310C5F81F61EB4B9759ACDA421643B3CDAA7BE5FC9B7C7318560516052EE1B447FC8C9E8B72F3896DA4E085DF2626F86BBDA35E92EF965BC5F7E9E7B4A2FE154FF2586277A58B246D5AD89232D603FB295AA1F0258CA5B646DC7CB4B3E548FA8B2724D87241FDF328872DF2D75068B29BB2C4A2CB9227CB59C9CE96B45B03D59111B6B03FA45963C689B0889A528B559A2D5A5B4E058DF1742A1B2ED0A75AD50553C034AB9EC2D0CA55B31933EFC2C61B70CE0BBACF11D73ADBC386DC404233E642727E7EDC4B85D3C1B2EA0554BAD7059895B22EB7E8DC13D28C6AA35B12B6DDDBEEB53AFB7F61295EA33C0F1E3842EBE6470B869E893B836070A2DDCFBD5BAF23AD938D678DCDEA789593FF7F59FDCE6A99AC5AFABDC3EAA84A0331802537D260FA544F1AC7DCFD963D8949B948D71B72DCBBAC1DA915CB508C8B2EC2A62CDEA394851D8F5DC533EC9AFD87D25978D403ED8B34594664459AFC2388B788717196F2ACD269FB845031D3D741E174BEBD6F0F8785231EEA9BBDA748E930588EAD88C9ACFEEC88CA39CAF0FA2592CDCBDFED415E8F9F4870597FB1267949267514DEA4A9C4A902551F171BFC554759982F14D60E79BE50C239C42933D6D27E9053B5968FDE4BAC924A075F23CF0B426FB397227CC813B812F7EBDC7D9DBBA3CE5DD90CABA81DF4E47A0CB22526F33ABD5EA7978FE955C3E93A4882079479D6941CF51E2CE9A60509CBE4CB621D68252F5D236A9283AE129D8EB884C0E1210E5CA8BC87AE8B90918EFE1252BE32D5D78F4E0B14F75A1373B64C3EB951BD4AC278BB14EE16EB1FF70C4B86F4025E714427B974C59096C661E167A47137457FFAB25DA82CA4F683ADADAD1C8E1E63FC4A5664BE547588DF3DF9EEE04CD5448409717E6D2CD848F17E6C6CADFE465A9242CFD305B484B28DF71E893B36DC322BB3F1891277BAB52E2D5BE0856FF9C04D43DF475794BB861EEEC7B5CCEF0CAFABFCF3368ECFA7AB20E6CF2DE1A2E243BF5D102C496DE6C1FD74470C10C1201F536572340FC3D88AD8371095F9D7E04C43BD5E3D02AD1BC6842C037C91768DAE7F69FF6EB30CD411FE4CEA815244241EB5144D5E671BE043FEAB22D30916C453B424E1FE5528C8112940F07A114788841E3405F0A62C5AA1BCB84BBFA1E47C7A7A7C723A9DBC8DA320AF5244D4C90CDEF069FE41D90D4E7E24D90DD0723DE3ABDBE7482054F27C194B322490092A2A7B2EB3C1DF91800AF1910583417036E3A99C718015085419D8B749F4EB1645E5FE7C554663121492E88D1689332D5D45CA808AFA3DF9AF25C1CA80A8EA274F4116E2FDEEEFD6C1F3EF0D946803423B12CAF87AD84818E2E0CC232110F034126C343E2BC0E9E43A78FE849287E2F17CFAD3B1356D731CBEAA13C22B1C57C9123D9F4FFFB3A4FC6672F5EF0B13F11F265F32BC20BC991C4FFE8BE6BC7CC2C38D71E1484A23AE93D39F3DB5CA84ED0FD2221DA9EFB741F07A02000047ABCB78F73CB07E00EF05D99A9401156B5162BFF86AD203B81305A400A8886728881DA9EF823ADCF914A2FD3BC9918DF097921287D95689392A30B99D2A2F6A0ABC9254534457815463D7B9556BD7CA69395A2EC42E2CDAC8F8DDF4FB019BDF5FCBE6DE4CEEF0A8B0D31134E4325951A3DE17EB271E586FC7ABE3DC91AFB87DF5FC54D673F5F20E1D44986D06EF9449AB753465FDAD00DDA7A7A5B03BC1A5C4C242EAC0B968130AE8277847AC289C47ABFEE04147E4EFD39E3A249DF637190AA3BCDC03FF9BB539B14BC240EDDD7AE15D3A71ADB79D92FC0E82E85502B16B62171ED153035C8A07BF5B37658E07F7C5BE4DEFE0BECB67B23AE83A4C4E7D2C692B8ECB3A2CE5528A70E3DD663D97E66C18C1B01BCA58B3D38CD66697373DABB8B3818F8CFEEC16226C189C1DE4E7651495465BBF03EC95BF134FC6B357A64E9D4E417691869E95968BBE85F0ECA06541076374B8587DCC90FED6FE52DE7AFD8212949140FA1B728C9025E569FD665B101567291E65360B776DAB485EE14E509AAEC29D9C323B85D771A4827AFDDA4754886F874B8BFD391754E6B7E8C0988266A78379798E8C2ED708328A9D548F36C1865F746B5C097CD8AD02D97E8C5775F28CFDB393803ADA1B988CE704166AD9664C34D92DE08302F070818C8C05BA1DACC4FD1C7753168D2ECBB2967497D5994ACAE157DBEEB71AD7DBCD40E4B003912F28A2BA43BABDB5BE1DBBDD50EC7A30D9E61431B884807AB9CB2AE2815AAF5B0BF0122FF35B832DEC4A6F6FF3620EB0776DD5E3B0FB34400097D7F925C963E1D733017A1BD1A51342309A79EC81BE2B62249A5FE93001621AD2A73FFDC95AF06C6C985FBE25E1DABEFD8614317A9EE5CF45BBF5E29563B457CCB77C96ABAE36420CB6089BE37964DEA0FA681DF3FA2DB6DAFD74C0787A0133C1F8AE75F12B6369753C0BA803E2A0D6A52594948162AF303A5C188131A08C1FF3E21D2E77D232078279F42AF7E7056AE395CE76AEC3113C13DC66BD7550C1809AF3AC5B5FF9DAA43A6240FA3A65C317FF7C26D680B5A3658859389F1E1F1D9D08FD95BE0ACA50647E6729FE4120875186B2CA9CB8C07BC1220B2231E0EF26C36B6AB40962495FB8B28EA09FB54DF05FDEA30DDE9F92484EB1D79EDA6E9BE0A69449364C1C8F112DB5BB40F37670AE440AE55AC00D6BFB333BAA0090C800D21338549E118AF151B942383A43B860692C3E87C1DDE2A3EA011416263C442C516607597F58EB34787658F101EBA1467D173559A612F8A87E2E45F1BE3D3F90D4075B2DD556AD82018174FD41449774DCFE66CB16356CEF211C80DF3D181E4CFA9BC38E4832C0886998A3C97E0300F430B1647834C18D8111302409887132592CD69E11D69DF16C0BF93652F59292E37A76185D1B06DD86D4221A80B297FE1C48B98F87047ED36B1F8EDE0BFDA2D52EA5CA18D052BD083216C498EA32FB4E4BFFBB839B280E90C167F97CCB283A9B74CDF3D6C1065B23E16A5C7BCF0DD57B081E79AC4C7F675E636ABE033AFD1AD9961B1E8A4D0EAD814F404C676BDFCB7A656764EDDB3AC53F1639A8B27B3D24B3B399802F770E8222A98BC982CAE1AA4452FD991EEEE627387AE41E2E224DA1442F585266E7B3706BB4820F3495B4B557C540E8115E76A291A3CEA2DC0F8A68E716911EF3F57B428F3E81F4BE22A7CEEC4F9C196AE4D0F9A85FA1B397D001F87F8DA7B368FC485E437CD55C7BA2B9F604448CF9ECCBD4D9E373EDC111626D98EF0122C8B5D7C2B0C9363B9BF0CC7F49AA374227E4F16712137111E46120BE7B51E670D6B43CBC37D4801E2A9D6F1C87C68822BD6F2727C7BD7387B3F257FCA73E69719F8830B53B1C344AAFDADB3251EE1C15EF77697287D33123B9D68EA161ACF069CE2F3D3A705E41323648C64603E5A0BED0BC4AD4CD3D5F870D3A4A8426C7FCFEDDF9E6EB5F66DA0FDFFC4BF6618D1630DC23180250EAD75644804D27BB90111968AAE7342A055B65764C48EEECBB2A04851681044F6CABCCCA22B4CA7CD5B74A2B7B68ABEA1681ADE59096E4AD405A80506F2F93658DB41F8D6D35179BA036A93DA9AC55FAFD2963BBBBA40D909659A75859E36C0973FB21551EC402E7A521E3812B6266824B5F6164A351EE42E3CD077D93952E8336239C54295A15CA4198A8C3EED7D4039D30AE98C35705474C191037017DC06C6284D17C020BCC577DE374C02012DB659F563204EB4DA8D2E22AAA8EEB539B0E6DB7B9DF05CDA6B023A9FACCEFFC2107DB4D980884083479F7F5816A3CEBDC92DA70DEFE6CEEB8ACD37E3ACC843EC93BAB8E8E128FAC58364D5DB3138C5B07B5513EF20EC3038334A7AE6C97A80F7A91703E0E402A5D4523E839835CF8F23D0B45A6A51B22EC37EF62A9669A591CB24324B779DC5D7C6EDD363DFD2995818D533FDF31A9E1D3748EFBB88F2252FA994344057352EF4F6412A7740B6A1E2656E52B0D985912A76AFF2B8CBB603D88A2D5776661281C677DDA1B434D26D1E3D4D47FA967AA7F2C98AC98AEDD157C284DFDD63B5D1EB00D62760A9488C6D293507AAE4D75A9F9492312EDB695222294E82C20B8DF9B44508E4E73DE0426D951530498AF9D0565E1E6259194AB93D8418A0AEAD5049E7A0687A8839E80CC3AAC5E9364C57C0B6140D5DCBAA7A80F7F44EF95AE8701FD9E7308DE14FAAEA9AEF2BA9D490DDF65939780E1740FEA5FE007DEC31CF1F177E006111C7477D597BC925E036F84BD1EEC4A8EBCCBFACCEF603134A9E9DAABCBF6DBD9AC3A31AF7FC07F1669163CA0EB7489E2BCFCF56C764BDE7B595749EDCE30E2A3871D89334C3341A55FDD8E6853E62A59A5CDD52DC7515384CBC1778D8A80DC2CBECD8A68158405FE1CA23C8F9287E9E41F41BCC5452EB11A5B5E255FB6C5664B4C00ACD6E2175A18E4E657D7FED94CE0F9EC4B99EE38F7D105CC664452317F49DE6DB159D9F2FD4192395241825C29D769B0C95816241DF6C34B4BE9739A0009D5E26B6FC2EFD07A136362F997641E902CFAF6BC7DCDD127F410842FF8F7A7684962335544CC03C18AFDEC7D143C64C13AAF69ECEAE33F318697EBE7BFFC1F00106DEAE8710100, N'6.1.3-40302')
GO
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'df25cbd3-6fc7-4083-ba73-093187c82be9', N'00000000-0000-0000-0000-000000000003', 1, NULL, CAST(N'2021-09-20T16:38:53.7400387' AS DateTime2), CAST(N'2021-09-20T16:38:57.3650386' AS DateTime2), CAST(N'2021-09-20T16:39:06.8650374' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'df25cbd3-6fc7-4083-ba73-093187c82be9', CAST(N'2021-09-20T00:00:00.0000000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'560dbdc4-ed65-42f2-a16b-0e9560b68c10', N'00000000-0000-0000-0000-000000000001', 1, NULL, CAST(N'2021-09-22T06:00:00.6315895' AS DateTime2), CAST(N'2021-09-22T06:00:00.8972357' AS DateTime2), CAST(N'2021-09-22T06:00:03.0066155' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'560dbdc4-ed65-42f2-a16b-0e9560b68c10', CAST(N'2021-09-22T05:59:55.4900000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'27473f30-8fe5-48ed-a8a0-1f9b130bd98c', N'00000000-0000-0000-0000-000000000003', 1, 1, CAST(N'2021-09-20T16:38:57.3650386' AS DateTime2), CAST(N'2021-09-20T16:38:59.3650505' AS DateTime2), CAST(N'2021-09-20T16:39:06.3963307' AS DateTime2), 0, 1, 100, NULL, N'Succeeded', 0, NULL, N'df25cbd3-6fc7-4083-ba73-093187c82be9', N'df25cbd3-6fc7-4083-ba73-093187c82be9', CAST(N'2021-09-20T00:00:00.0000000' AS DateTime2), N'eba6b22f-f657-4919-8e2b-00eb339eb5bd')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'3c0fc7ff-f937-4aa8-bb6e-22c766c94767', N'00000000-0000-0000-0000-000000000003', 1, NULL, CAST(N'2021-09-21T00:00:08.1957915' AS DateTime2), CAST(N'2021-09-21T00:00:08.4457856' AS DateTime2), CAST(N'2021-09-21T00:00:13.3520568' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'3c0fc7ff-f937-4aa8-bb6e-22c766c94767', CAST(N'2021-09-21T00:00:00.0000000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'996b0e9a-71ed-4b9f-8075-3de8ea2362cb', N'00000000-0000-0000-0000-000000000001', 1, 1, CAST(N'2021-09-22T06:00:00.8972357' AS DateTime2), CAST(N'2021-09-22T06:00:01.2253852' AS DateTime2), CAST(N'2021-09-22T06:00:02.4128658' AS DateTime2), 0, 1, 1000, NULL, N'Succeeded', 0, NULL, N'560dbdc4-ed65-42f2-a16b-0e9560b68c10', N'560dbdc4-ed65-42f2-a16b-0e9560b68c10', CAST(N'2021-09-22T05:59:55.4900000' AS DateTime2), N'ad160705-87a1-4034-872f-d9b9484bde54')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'eeccdae6-0e66-458d-bcfa-4eb398ddd9e1', N'00000000-0000-0000-0000-000000000001', 1, NULL, CAST(N'2021-09-20T16:38:53.7400387' AS DateTime2), CAST(N'2021-09-20T16:38:56.7869372' AS DateTime2), CAST(N'2021-09-20T16:39:04.7244360' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'eeccdae6-0e66-458d-bcfa-4eb398ddd9e1', CAST(N'2021-09-20T04:17:36.7690000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'8b433e28-3cd0-418a-a3f2-68a03b084b96', N'00000000-0000-0000-0000-000000000003', 1, NULL, CAST(N'2021-09-22T00:00:07.3544870' AS DateTime2), CAST(N'2021-09-22T00:00:07.5732393' AS DateTime2), CAST(N'2021-09-22T00:00:12.4951228' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'8b433e28-3cd0-418a-a3f2-68a03b084b96', CAST(N'2021-09-22T00:00:00.0000000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'6cac2859-7253-44a1-bd87-6cb7e1660eab', N'00000000-0000-0000-0000-000000000003', 1, 1, CAST(N'2021-09-21T00:00:08.4457856' AS DateTime2), CAST(N'2021-09-21T00:00:08.8051663' AS DateTime2), CAST(N'2021-09-21T00:00:12.8364388' AS DateTime2), 0, 1, 100, NULL, N'Succeeded', 0, NULL, N'3c0fc7ff-f937-4aa8-bb6e-22c766c94767', N'3c0fc7ff-f937-4aa8-bb6e-22c766c94767', CAST(N'2021-09-21T00:00:00.0000000' AS DateTime2), N'65b5a89f-2cb1-4852-947f-a1b034430d28')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'df334e82-cf40-4a0f-bb0f-ae51d751e179', N'00000000-0000-0000-0000-000000000001', 1, 1, CAST(N'2021-09-20T16:38:56.7869372' AS DateTime2), CAST(N'2021-09-20T16:38:57.3807043' AS DateTime2), CAST(N'2021-09-20T16:39:04.0213324' AS DateTime2), 0, 1, 1000, NULL, N'Succeeded', 0, NULL, N'eeccdae6-0e66-458d-bcfa-4eb398ddd9e1', N'eeccdae6-0e66-458d-bcfa-4eb398ddd9e1', CAST(N'2021-09-20T04:17:36.7690000' AS DateTime2), N'3e3922ab-a3cb-4995-9138-03b93b57b091')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'b9a24d5b-4c56-4916-a497-e715203a8c6a', N'00000000-0000-0000-0000-000000000001', 1, 1, CAST(N'2021-09-21T22:42:04.9993643' AS DateTime2), CAST(N'2021-09-21T22:42:06.0462366' AS DateTime2), CAST(N'2021-09-21T22:42:10.7805736' AS DateTime2), 0, 1, 1000, NULL, N'Succeeded', 0, NULL, N'5f2363ec-ce83-4969-a11e-f58e39436fb8', N'5f2363ec-ce83-4969-a11e-f58e39436fb8', CAST(N'2021-09-21T05:59:55.4900000' AS DateTime2), N'7ca13314-8493-4c58-839a-d6b340a5ea1d')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'30faf516-cf57-4730-b898-e8855efe4a59', N'00000000-0000-0000-0000-000000000001', 1, 1, CAST(N'2021-09-21T05:48:45.9510679' AS DateTime2), CAST(N'2021-09-21T05:48:46.5136616' AS DateTime2), CAST(N'2021-09-21T05:48:52.4354889' AS DateTime2), 0, 1, 1000, NULL, N'Succeeded', 0, NULL, N'c971ba7d-11df-423e-89a1-ec13e9cb3c5f', N'c971ba7d-11df-423e-89a1-ec13e9cb3c5f', CAST(N'2021-09-21T05:48:35.4900000' AS DateTime2), N'63670820-6baf-4e25-b8ef-431246d4611f')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'c971ba7d-11df-423e-89a1-ec13e9cb3c5f', N'00000000-0000-0000-0000-000000000001', 1, NULL, CAST(N'2021-09-21T05:48:42.8104244' AS DateTime2), CAST(N'2021-09-21T05:48:45.9510679' AS DateTime2), CAST(N'2021-09-21T05:48:52.6698735' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'c971ba7d-11df-423e-89a1-ec13e9cb3c5f', CAST(N'2021-09-21T05:48:35.4900000' AS DateTime2), NULL)
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'7d0a6e45-46d5-48dc-8aba-f0cd3d9d068e', N'00000000-0000-0000-0000-000000000003', 1, 1, CAST(N'2021-09-22T00:00:07.5732393' AS DateTime2), CAST(N'2021-09-22T00:00:07.8232242' AS DateTime2), CAST(N'2021-09-22T00:00:12.1044945' AS DateTime2), 0, 1, 100, NULL, N'Succeeded', 0, NULL, N'8b433e28-3cd0-418a-a3f2-68a03b084b96', N'8b433e28-3cd0-418a-a3f2-68a03b084b96', CAST(N'2021-09-22T00:00:00.0000000' AS DateTime2), N'a841e04a-4cd5-47a1-a473-d6296e8d1360')
INSERT [jobs_internal].[job_executions] ([job_execution_id], [job_id], [job_version_number], [step_id], [create_time], [start_time], [end_time], [infrastructure_failures], [current_task_attempts], [next_retry_delay_ms], [do_not_retry_until_time], [lifecycle], [is_active], [target_id], [parent_job_execution_id], [root_job_execution_id], [initiated_for_schedule_time], [last_job_task_execution_id]) VALUES (N'5f2363ec-ce83-4969-a11e-f58e39436fb8', N'00000000-0000-0000-0000-000000000001', 1, NULL, CAST(N'2021-09-21T22:42:02.4837488' AS DateTime2), CAST(N'2021-09-21T22:42:04.9993643' AS DateTime2), CAST(N'2021-09-21T22:42:11.0149709' AS DateTime2), 0, 0, 0, NULL, N'Succeeded', 0, NULL, NULL, N'5f2363ec-ce83-4969-a11e-f58e39436fb8', CAST(N'2021-09-21T05:59:55.4900000' AS DateTime2), NULL)
GO
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'eba6b22f-f657-4919-8e2b-00eb339eb5bd', N'27473f30-8fe5-48ed-a8a0-1f9b130bd98c', N'3c5ecacb-d51d-474f-afd9-7bacc039768a', N'DeleteUnusedCommandData', N'Succeeded', 0, CAST(N'2021-09-20T16:39:05.9431840' AS DateTime2), CAST(N'2021-09-20T16:39:06.0212878' AS DateTime2), CAST(N'2021-09-20T16:39:06.2557289' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'3e3922ab-a3cb-4995-9138-03b93b57b091', N'df334e82-cf40-4a0f-bb0f-ae51d751e179', NULL, N'TelemetryCollection', N'Succeeded', 0, CAST(N'2021-09-20T16:38:57.3807043' AS DateTime2), CAST(N'2021-09-20T16:38:57.5369611' AS DateTime2), CAST(N'2021-09-20T16:39:03.3650407' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'9a6e705f-00f8-477f-bdb0-385f23d1a2d7', N'6cac2859-7253-44a1-bd87-6cb7e1660eab', N'28cabbdc-616f-49f8-b90d-86667278b3f8', N'DeleteExpiredHistory', N'Succeeded', 0, CAST(N'2021-09-21T00:00:09.7738976' AS DateTime2), CAST(N'2021-09-21T00:00:09.8832947' AS DateTime2), CAST(N'2021-09-21T00:00:10.4301921' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'63670820-6baf-4e25-b8ef-431246d4611f', N'30faf516-cf57-4730-b898-e8855efe4a59', NULL, N'TelemetryCollection', N'Succeeded', 0, CAST(N'2021-09-21T05:48:46.5136616' AS DateTime2), CAST(N'2021-09-21T05:48:46.6698190' AS DateTime2), CAST(N'2021-09-21T05:48:51.8885978' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'893b0ca9-90da-404d-8a8a-4cfe56a34245', N'6cac2859-7253-44a1-bd87-6cb7e1660eab', N'9a6e705f-00f8-477f-bdb0-385f23d1a2d7', N'DeleteUnusedJobStepData', N'Succeeded', 0, CAST(N'2021-09-21T00:00:10.9614265' AS DateTime2), CAST(N'2021-09-21T00:00:11.1801515' AS DateTime2), CAST(N'2021-09-21T00:00:11.5551783' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'8bcd2ab5-9ef2-485e-88de-577be6d69bda', N'7d0a6e45-46d5-48dc-8aba-f0cd3d9d068e', N'22b3b732-948c-4f1e-a447-686f1899511e', N'DeleteUnusedJobStepData', N'Succeeded', 0, CAST(N'2021-09-22T00:00:10.3232227' AS DateTime2), CAST(N'2021-09-22T00:00:10.4482428' AS DateTime2), CAST(N'2021-09-22T00:00:10.7138692' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'9089641b-24af-4f37-a8f7-5e46eb7ef54b', N'27473f30-8fe5-48ed-a8a0-1f9b130bd98c', NULL, N'DeleteTombstonedJobs', N'Succeeded', 0, CAST(N'2021-09-20T16:38:59.3650505' AS DateTime2), CAST(N'2021-09-20T16:38:59.7400830' AS DateTime2), CAST(N'2021-09-20T16:39:02.3963192' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'22b3b732-948c-4f1e-a447-686f1899511e', N'7d0a6e45-46d5-48dc-8aba-f0cd3d9d068e', N'bcf1166a-ee3f-45e6-8aea-df81d5e04e72', N'DeleteExpiredHistory', N'Succeeded', 0, CAST(N'2021-09-22T00:00:09.0107260' AS DateTime2), CAST(N'2021-09-22T00:00:09.1201235' AS DateTime2), CAST(N'2021-09-22T00:00:09.9951170' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'3c5ecacb-d51d-474f-afd9-7bacc039768a', N'27473f30-8fe5-48ed-a8a0-1f9b130bd98c', N'67d906bb-423b-4be7-b319-b5445ae3ba8e', N'DeleteUnusedJobStepData', N'Succeeded', 0, CAST(N'2021-09-20T16:39:04.7088109' AS DateTime2), CAST(N'2021-09-20T16:39:05.1619337' AS DateTime2), CAST(N'2021-09-20T16:39:05.1775679' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'28cabbdc-616f-49f8-b90d-86667278b3f8', N'6cac2859-7253-44a1-bd87-6cb7e1660eab', NULL, N'DeleteTombstonedJobs', N'Succeeded', 0, CAST(N'2021-09-21T00:00:08.8051663' AS DateTime2), CAST(N'2021-09-21T00:00:08.9303216' AS DateTime2), CAST(N'2021-09-21T00:00:09.1957987' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'65b5a89f-2cb1-4852-947f-a1b034430d28', N'6cac2859-7253-44a1-bd87-6cb7e1660eab', N'893b0ca9-90da-404d-8a8a-4cfe56a34245', N'DeleteUnusedCommandData', N'Succeeded', 0, CAST(N'2021-09-21T00:00:12.1645639' AS DateTime2), CAST(N'2021-09-21T00:00:12.2739360' AS DateTime2), CAST(N'2021-09-21T00:00:12.3989120' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'67d906bb-423b-4be7-b319-b5445ae3ba8e', N'27473f30-8fe5-48ed-a8a0-1f9b130bd98c', N'9089641b-24af-4f37-a8f7-5e46eb7ef54b', N'DeleteExpiredHistory', N'Succeeded', 0, CAST(N'2021-09-20T16:39:03.3025406' AS DateTime2), CAST(N'2021-09-20T16:39:03.3806648' AS DateTime2), CAST(N'2021-09-20T16:39:03.9744592' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'a841e04a-4cd5-47a1-a473-d6296e8d1360', N'7d0a6e45-46d5-48dc-8aba-f0cd3d9d068e', N'8bcd2ab5-9ef2-485e-88de-577be6d69bda', N'DeleteUnusedCommandData', N'Succeeded', 0, CAST(N'2021-09-22T00:00:11.3075835' AS DateTime2), CAST(N'2021-09-22T00:00:11.4325915' AS DateTime2), CAST(N'2021-09-22T00:00:11.9013482' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'7ca13314-8493-4c58-839a-d6b340a5ea1d', N'b9a24d5b-4c56-4916-a497-e715203a8c6a', NULL, N'TelemetryCollection', N'Succeeded', 0, CAST(N'2021-09-21T22:42:06.0462366' AS DateTime2), CAST(N'2021-09-21T22:42:06.2024613' AS DateTime2), CAST(N'2021-09-21T22:42:10.2181058' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'ad160705-87a1-4034-872f-d9b9484bde54', N'996b0e9a-71ed-4b9f-8075-3de8ea2362cb', NULL, N'TelemetryCollection', N'Succeeded', 0, CAST(N'2021-09-22T06:00:01.2253852' AS DateTime2), CAST(N'2021-09-22T06:00:01.3347413' AS DateTime2), CAST(N'2021-09-22T06:00:01.8816112' AS DateTime2), NULL, NULL)
INSERT [jobs_internal].[job_task_executions] ([job_task_execution_id], [job_execution_id], [previous_job_task_execution_id], [task_type], [lifecycle], [is_active], [create_time], [start_time], [end_time], [message], [exception]) VALUES (N'bcf1166a-ee3f-45e6-8aea-df81d5e04e72', N'7d0a6e45-46d5-48dc-8aba-f0cd3d9d068e', NULL, N'DeleteTombstonedJobs', N'Succeeded', 0, CAST(N'2021-09-22T00:00:07.8232242' AS DateTime2), CAST(N'2021-09-22T00:00:07.9013497' AS DateTime2), CAST(N'2021-09-22T00:00:08.4794759' AS DateTime2), NULL, NULL)
GO
INSERT [jobs_internal].[job_versions] ([job_id], [job_version_number]) VALUES (N'00000000-0000-0000-0000-000000000001', 1)
INSERT [jobs_internal].[job_versions] ([job_id], [job_version_number]) VALUES (N'00000000-0000-0000-0000-000000000003', 1)
GO
INSERT [jobs_internal].[jobs] ([job_id], [name], [delete_requested_time], [is_system], [schedule_start_time], [schedule_end_time], [schedule_interval_type], [schedule_interval_count], [enabled], [description], [last_job_execution_id]) VALUES (N'00000000-0000-0000-0000-000000000001', N'##MS_Telemetry##', NULL, 1, CAST(N'2000-01-01T04:07:29.4940000' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2), N'Hours', 24, 1, N'', N'560dbdc4-ed65-42f2-a16b-0e9560b68c10')
INSERT [jobs_internal].[jobs] ([job_id], [name], [delete_requested_time], [is_system], [schedule_start_time], [schedule_end_time], [schedule_interval_type], [schedule_interval_count], [enabled], [description], [last_job_execution_id]) VALUES (N'00000000-0000-0000-0000-000000000003', N'##MS_Cleanup##', NULL, 1, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), CAST(N'9999-12-31T23:59:59.9999999' AS DateTime2), N'Hours', 24, 1, N'', N'8b433e28-3cd0-418a-a3f2-68a03b084b96')
GO
INSERT [jobs_internal].[jobstep_data] ([jobstep_data_id], [command_type], [result_set_destination_target_id], [result_set_destination_credential_name], [result_set_destination_schema_name], [result_set_destination_table_name], [command_data_id], [credential_name], [target_id], [initial_retry_interval_ms], [maximum_retry_interval_ms], [retry_interval_backoff_multiplier], [retry_attempts], [step_timeout_ms], [max_parallelism]) VALUES (N'00000000-0000-0000-0000-000000000001', N'TelemetryCollection', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1000, 1800000, 1.5, 5, 300000, NULL)
INSERT [jobs_internal].[jobstep_data] ([jobstep_data_id], [command_type], [result_set_destination_target_id], [result_set_destination_credential_name], [result_set_destination_schema_name], [result_set_destination_table_name], [command_data_id], [credential_name], [target_id], [initial_retry_interval_ms], [maximum_retry_interval_ms], [retry_interval_backoff_multiplier], [retry_attempts], [step_timeout_ms], [max_parallelism]) VALUES (N'00000000-0000-0000-0000-000000000003', N'Cleanup', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, 1800000, 1.1, 10, 7200000, NULL)
GO
INSERT [jobs_internal].[jobsteps] ([job_id], [job_version_number], [step_id], [jobstep_data_id], [step_name]) VALUES (N'00000000-0000-0000-0000-000000000001', 1, 1, N'00000000-0000-0000-0000-000000000001', N'##MS_Telemetry##')
INSERT [jobs_internal].[jobsteps] ([job_id], [job_version_number], [step_id], [jobstep_data_id], [step_name]) VALUES (N'00000000-0000-0000-0000-000000000003', 1, 1, N'00000000-0000-0000-0000-000000000003', N'##MS_Cleanup##')
GO
INSERT [UserData].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'965b4b9f-0503a7c9-9cf6354b', N'CLOPEZ', N'36502', NULL)
INSERT [UserData].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'c5296d36-9cf6354b-2e236be4', N'USER1', N'36501', NULL)
INSERT [UserData].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd9ac8848-18e03417-a951a0aa', N'CLOPEZ', N'36502', NULL)
INSERT [UserData].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd9ac8848-18e03417-a951a0aa', N'USER2', N'36501', NULL)
INSERT [UserData].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'e603a25c-20201e0b-31497d1e', N'CLOPEZ', N'36501', NULL)
GO
INSERT [UserData2].[User] ([ID], [Restrict]) VALUES (N'User4', 1)
INSERT [UserData2].[User] ([ID], [Restrict]) VALUES (N'User5', 1)
INSERT [UserData2].[User] ([ID], [Restrict]) VALUES (N'user5@test.com', 1)
GO
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'18e03417-31497d1e-e6f79b53', N'User4', N'36501', 1)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'18e03417-31497d1e-e6f79b53', N'User4', N'36502', 1)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'18e03417-31497d1e-e6f79b53', N'User4', N'36503', 1)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'18e03417-31497d1e-e6f79b53', N'User4', N'36504', 1)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b190bf-18f03417-a951a1bc', N'User4', N'36501', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b190bf-18f03417-a951a1bc', N'User4', N'36502', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b190bf-18f03417-a951a1bc', N'User4', N'36503', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b190bf-18f03417-a951a1bc', N'User4', N'36504', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b199bf-18f03316-a901a1bc', N'User6', N'36501', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b199bf-18f03316-a901a1bc', N'User6', N'36502', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1ba', N'User5', N'36501', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1ba', N'User5', N'36502', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1ba', N'User5', N'36503', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1ba', N'User5', N'36504', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'User5', N'36501', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'User5', N'36502', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'User5', N'36503', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'User5', N'36504', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'user5@test.com', N'36501', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'user5@test.com', N'36502', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'user5@test.com', N'36503', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'd7b940bf-18f03417-a951a1bc', N'user5@test.com', N'36504', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'e603a25c-e6f79b53-1a0c6acf', N'User5', N'36501', 1)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'e603a25c-e6f79b53-1a0c6acf', N'User5', N'36503', 0)
INSERT [UserData2].[Variable] ([VariableID], [UserID], [Values], [Unrestricted]) VALUES (N'e603a25c-e6f79b53-1a0c6acf', N'User5', N'36504', 1)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UK_principal_name]    Script Date: 9/22/2021 5:44:27 PM ******/
ALTER TABLE [dbo].[sysdiagrams] ADD  CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dcnserver].[tbl_range] ADD  CONSTRAINT [DF_range_date_UTC]  DEFAULT ('1900-01-01') FOR [date_UTC]
GO
ALTER TABLE [jobs_internal].[jobsteps] ADD  DEFAULT ('JobStep') FOR [step_name]
GO
ALTER TABLE [dbo].[Tests_A]  WITH CHECK ADD FOREIGN KEY([fk_Tests_A_vId])
REFERENCES [dbo].[Tests_A] ([Variable_ID])
GO
ALTER TABLE [dbo].[Tests_B]  WITH CHECK ADD FOREIGN KEY([fk_Value_vId])
REFERENCES [dbo].[TestsValue_B] ([Variable_ID])
GO
ALTER TABLE [jobs_internal].[job_cancellations]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_cancellations_jobs_internal.job_executions_job_execution_id] FOREIGN KEY([job_execution_id])
REFERENCES [jobs_internal].[job_executions] ([job_execution_id])
GO
ALTER TABLE [jobs_internal].[job_cancellations] CHECK CONSTRAINT [FK_jobs_internal.job_cancellations_jobs_internal.job_executions_job_execution_id]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_executions_parent_job_execution_id] FOREIGN KEY([parent_job_execution_id])
REFERENCES [jobs_internal].[job_executions] ([job_execution_id])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_executions_parent_job_execution_id]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_executions_root_job_execution_id] FOREIGN KEY([root_job_execution_id])
REFERENCES [jobs_internal].[job_executions] ([job_execution_id])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_executions_root_job_execution_id]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_task_executions_last_job_task_execution_id] FOREIGN KEY([last_job_task_execution_id])
REFERENCES [jobs_internal].[job_task_executions] ([job_task_execution_id])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_task_executions_last_job_task_execution_id]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_versions_job_id_job_version_number] FOREIGN KEY([job_id], [job_version_number])
REFERENCES [jobs_internal].[job_versions] ([job_id], [job_version_number])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.job_versions_job_id_job_version_number]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.jobsteps_job_id_job_version_number_step_id] FOREIGN KEY([job_id], [job_version_number], [step_id])
REFERENCES [jobs_internal].[jobsteps] ([job_id], [job_version_number], [step_id])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.jobsteps_job_id_job_version_number_step_id]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.targets_target_id] FOREIGN KEY([target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [FK_jobs_internal.job_executions_jobs_internal.targets_target_id]
GO
ALTER TABLE [jobs_internal].[job_task_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_task_executions_jobs_internal.job_executions_job_execution_id] FOREIGN KEY([job_execution_id])
REFERENCES [jobs_internal].[job_executions] ([job_execution_id])
GO
ALTER TABLE [jobs_internal].[job_task_executions] CHECK CONSTRAINT [FK_jobs_internal.job_task_executions_jobs_internal.job_executions_job_execution_id]
GO
ALTER TABLE [jobs_internal].[job_task_executions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_task_executions_jobs_internal.job_task_executions_previous_job_task_execution_id] FOREIGN KEY([previous_job_task_execution_id])
REFERENCES [jobs_internal].[job_task_executions] ([job_task_execution_id])
GO
ALTER TABLE [jobs_internal].[job_task_executions] CHECK CONSTRAINT [FK_jobs_internal.job_task_executions_jobs_internal.job_task_executions_previous_job_task_execution_id]
GO
ALTER TABLE [jobs_internal].[job_versions]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.job_versions_jobs_internal.jobs_job_id] FOREIGN KEY([job_id])
REFERENCES [jobs_internal].[jobs] ([job_id])
GO
ALTER TABLE [jobs_internal].[job_versions] CHECK CONSTRAINT [FK_jobs_internal.job_versions_jobs_internal.jobs_job_id]
GO
ALTER TABLE [jobs_internal].[jobs]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobs_jobs_internal.job_executions_last_job_execution_id] FOREIGN KEY([last_job_execution_id])
REFERENCES [jobs_internal].[job_executions] ([job_execution_id])
GO
ALTER TABLE [jobs_internal].[jobs] CHECK CONSTRAINT [FK_jobs_internal.jobs_jobs_internal.job_executions_last_job_execution_id]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.command_data_command_data_id] FOREIGN KEY([command_data_id])
REFERENCES [jobs_internal].[command_data] ([command_data_id])
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.command_data_command_data_id]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.targets_result_set_destination_target_id] FOREIGN KEY([result_set_destination_target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.targets_result_set_destination_target_id]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.targets_target_id] FOREIGN KEY([target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [FK_jobs_internal.jobstep_data_jobs_internal.targets_target_id]
GO
ALTER TABLE [jobs_internal].[jobsteps]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.job_versions_job_id_job_version_number] FOREIGN KEY([job_id], [job_version_number])
REFERENCES [jobs_internal].[job_versions] ([job_id], [job_version_number])
GO
ALTER TABLE [jobs_internal].[jobsteps] CHECK CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.job_versions_job_id_job_version_number]
GO
ALTER TABLE [jobs_internal].[jobsteps]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.jobs_job_id] FOREIGN KEY([job_id])
REFERENCES [jobs_internal].[jobs] ([job_id])
ON DELETE CASCADE
GO
ALTER TABLE [jobs_internal].[jobsteps] CHECK CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.jobs_job_id]
GO
ALTER TABLE [jobs_internal].[jobsteps]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.jobstep_data_jobstep_data_id] FOREIGN KEY([jobstep_data_id])
REFERENCES [jobs_internal].[jobstep_data] ([jobstep_data_id])
GO
ALTER TABLE [jobs_internal].[jobsteps] CHECK CONSTRAINT [FK_jobs_internal.jobsteps_jobs_internal.jobstep_data_jobstep_data_id]
GO
ALTER TABLE [jobs_internal].[script_batches]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.script_batches_jobs_internal.command_data_command_data_id] FOREIGN KEY([command_data_id])
REFERENCES [jobs_internal].[command_data] ([command_data_id])
GO
ALTER TABLE [jobs_internal].[script_batches] CHECK CONSTRAINT [FK_jobs_internal.script_batches_jobs_internal.command_data_command_data_id]
GO
ALTER TABLE [jobs_internal].[target_associations]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.target_associations_jobs_internal.targets_child_target_id] FOREIGN KEY([child_target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[target_associations] CHECK CONSTRAINT [FK_jobs_internal.target_associations_jobs_internal.targets_child_target_id]
GO
ALTER TABLE [jobs_internal].[target_associations]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.target_associations_jobs_internal.targets_parent_target_id] FOREIGN KEY([parent_target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[target_associations] CHECK CONSTRAINT [FK_jobs_internal.target_associations_jobs_internal.targets_parent_target_id]
GO
ALTER TABLE [jobs_internal].[target_group_memberships]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.target_group_memberships_jobs_internal.targets_child_target_id] FOREIGN KEY([child_target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[target_group_memberships] CHECK CONSTRAINT [FK_jobs_internal.target_group_memberships_jobs_internal.targets_child_target_id]
GO
ALTER TABLE [jobs_internal].[target_group_memberships]  WITH CHECK ADD  CONSTRAINT [FK_jobs_internal.target_group_memberships_jobs_internal.targets_parent_target_id] FOREIGN KEY([parent_target_id])
REFERENCES [jobs_internal].[targets] ([target_id])
GO
ALTER TABLE [jobs_internal].[target_group_memberships] CHECK CONSTRAINT [FK_jobs_internal.target_group_memberships_jobs_internal.targets_parent_target_id]
GO
ALTER TABLE [UserData].[Variable]  WITH CHECK ADD  CONSTRAINT [FK_Variable_User] FOREIGN KEY([UserID])
REFERENCES [UserData].[User] ([ID])
GO
ALTER TABLE [UserData].[Variable] CHECK CONSTRAINT [FK_Variable_User]
GO
ALTER TABLE [jobs_internal].[command_data]  WITH CHECK ADD  CONSTRAINT [CK_command_data_large_command_unsupported] CHECK  ((datalength([text])<=((2)*(1024))*(1024)))
GO
ALTER TABLE [jobs_internal].[command_data] CHECK CONSTRAINT [CK_command_data_large_command_unsupported]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_executions_do_not_retry_time_not_null_only_when_lifecycle_waiting_for_retry] CHECK  (([lifecycle]='WaitingForRetry' AND [do_not_retry_until_time] IS NOT NULL OR [lifecycle]<>'WaitingForRetry' AND [do_not_retry_until_time] IS NULL))
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [CK_job_executions_do_not_retry_time_not_null_only_when_lifecycle_waiting_for_retry]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_executions_end_time_not_null_only_when_is_active] CHECK  (([is_active]=(1) AND [end_time] IS NULL OR [is_active]=(0) AND [end_time] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [CK_job_executions_end_time_not_null_only_when_is_active]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_executions_lifecycle_is_active_valid] CHECK  (([lifecycle]='Created' AND [is_active]=(1) OR [lifecycle]='InProgress' AND [is_active]=(1) OR [lifecycle]='WaitingForChildJobExecutions' AND [is_active]=(1) OR [lifecycle]='WaitingForRetry' AND [is_active]=(1) OR [lifecycle]='Succeeded' AND [is_active]=(0) OR [lifecycle]='SucceededWithSkipped' AND [is_active]=(0) OR [lifecycle]='Failed' AND [is_active]=(0) OR [lifecycle]='TimedOut' AND [is_active]=(0) OR [lifecycle]='Canceled' AND [is_active]=(0) OR [lifecycle]='Skipped' AND [is_active]=(0)))
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [CK_job_executions_lifecycle_is_active_valid]
GO
ALTER TABLE [jobs_internal].[job_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_executions_start_time_not_null_only_when_lifecycle_created] CHECK  (([lifecycle]='Created' AND [start_time] IS NULL OR [lifecycle]<>'Created' AND [start_time] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[job_executions] CHECK CONSTRAINT [CK_job_executions_start_time_not_null_only_when_lifecycle_created]
GO
ALTER TABLE [jobs_internal].[job_task_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_task_executions_end_time_not_null_only_when_is_active] CHECK  (([is_active]=(1) AND [end_time] IS NULL OR [is_active]=(0) AND [end_time] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[job_task_executions] CHECK CONSTRAINT [CK_job_task_executions_end_time_not_null_only_when_is_active]
GO
ALTER TABLE [jobs_internal].[job_task_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_task_executions_lifecycle_is_active_valid] CHECK  (([lifecycle]='Created' AND [is_active]=(1) OR [lifecycle]='InProgress' AND [is_active]=(1) OR [lifecycle]='Succeeded' AND [is_active]=(0) OR [lifecycle]='Failed' AND [is_active]=(0) OR [lifecycle]='TimedOut' AND [is_active]=(0) OR [lifecycle]='Canceled' AND [is_active]=(0) OR [lifecycle]='Abandoned' AND [is_active]=(0)))
GO
ALTER TABLE [jobs_internal].[job_task_executions] CHECK CONSTRAINT [CK_job_task_executions_lifecycle_is_active_valid]
GO
ALTER TABLE [jobs_internal].[job_task_executions]  WITH CHECK ADD  CONSTRAINT [CK_job_task_executions_start_time_not_null_only_when_lifecycle_created] CHECK  (([lifecycle]='Created' AND [start_time] IS NULL OR [lifecycle]<>'Created' AND [start_time] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[job_task_executions] CHECK CONSTRAINT [CK_job_task_executions_start_time_not_null_only_when_lifecycle_created]
GO
ALTER TABLE [jobs_internal].[jobs]  WITH CHECK ADD  CONSTRAINT [CK_job_schedule_interval_count] CHECK  (([schedule_interval_count]>(0)))
GO
ALTER TABLE [jobs_internal].[jobs] CHECK CONSTRAINT [CK_job_schedule_interval_count]
GO
ALTER TABLE [jobs_internal].[jobs]  WITH CHECK ADD  CONSTRAINT [CK_job_schedule_interval_type] CHECK  (([schedule_interval_type]='Months' OR [schedule_interval_type]='Weeks' OR [schedule_interval_type]='Days' OR [schedule_interval_type]='Hours' OR [schedule_interval_type]='Minutes' OR [schedule_interval_type]='Once'))
GO
ALTER TABLE [jobs_internal].[jobs] CHECK CONSTRAINT [CK_job_schedule_interval_type]
GO
ALTER TABLE [jobs_internal].[jobs]  WITH CHECK ADD  CONSTRAINT [CK_job_schedule_start_time_end_time_ordered] CHECK  (([schedule_start_time]<=[schedule_end_time]))
GO
ALTER TABLE [jobs_internal].[jobs] CHECK CONSTRAINT [CK_job_schedule_start_time_end_time_ordered]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_command_type] CHECK  (([command_type]='Cleanup' OR [command_type]='TelemetryCollection' OR [command_type]='Dacpac' OR [command_type]='TSql'))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_command_type]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_initial_retry_interval_not_greater_than_than_maximum_retry_interval] CHECK  (([initial_retry_interval_ms]<=[maximum_retry_interval_ms]))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_initial_retry_interval_not_greater_than_than_maximum_retry_interval]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_initial_retry_interval_not_less_than_zero] CHECK  (([initial_retry_interval_ms]>=(0)))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_initial_retry_interval_not_less_than_zero]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_max_parallelism] CHECK  (([max_parallelism] IS NULL OR [max_parallelism]>(0)))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_max_parallelism]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_result_set_destination] CHECK  (([result_set_destination_target_id] IS NULL AND [result_set_destination_credential_name] IS NULL AND [result_set_destination_schema_name] IS NULL AND [result_set_destination_table_name] IS NULL OR [result_set_destination_target_id] IS NOT NULL AND [result_set_destination_credential_name] IS NOT NULL AND nullif([result_set_destination_schema_name],'') IS NOT NULL AND nullif([result_set_destination_table_name],'') IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_result_set_destination]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_retry_attempts_not_less_than_zero] CHECK  (([retry_attempts]>=(0)))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_retry_attempts_not_less_than_zero]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_retry_interval_backoff_multiplier_not_less_than_one] CHECK  (([retry_interval_backoff_multiplier]>=(1)))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_retry_interval_backoff_multiplier_not_less_than_one]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_step_timeout_greater_than_zero] CHECK  (([step_timeout_ms]>(0)))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_step_timeout_greater_than_zero]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_tsql_command_data_required] CHECK  (([command_type]<>'TSql' OR [command_data_id] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_tsql_command_data_required]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_tsql_credential_name_required] CHECK  (([command_type]<>'TSql' OR [credential_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_tsql_credential_name_required]
GO
ALTER TABLE [jobs_internal].[jobstep_data]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_data_tsql_target_id_required] CHECK  (([command_type]<>'TSql' OR [target_id] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[jobstep_data] CHECK CONSTRAINT [CK_jobstep_data_tsql_target_id_required]
GO
ALTER TABLE [jobs_internal].[jobsteps]  WITH CHECK ADD  CONSTRAINT [CK_jobstep_step_id_greater_than_zero] CHECK  (([step_id]>(0)))
GO
ALTER TABLE [jobs_internal].[jobsteps] CHECK CONSTRAINT [CK_jobstep_step_id_greater_than_zero]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_delete_requested_time_exclusive_to_target_group] CHECK  (([delete_requested_time] IS NULL OR [target_type]='TargetGroup'))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_delete_requested_time_exclusive_to_target_group]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_elastic_pool_name] CHECK  (([elastic_pool_name] IS NULL OR [target_type]='SqlElasticPool' OR [target_type]='SqlDatabase'))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_elastic_pool_name]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_shard_map_name_exclusive_to_shard_map_target] CHECK  (([shard_map_name] IS NULL OR [target_type]='SqlShardMap'))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_shard_map_name_exclusive_to_shard_map_target]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_database_target_database_name_not_null] CHECK  (([target_type]<>'SqlDatabase' OR [database_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_database_target_database_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_database_target_refresh_credential_name_null] CHECK  (([target_type]<>'SqlDatabase' OR [refresh_credential_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_database_target_refresh_credential_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_database_target_server_name_not_null] CHECK  (([target_type]<>'SqlDatabase' OR [server_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_database_target_server_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_elastic_pool_target_database_name_null] CHECK  (([target_type]<>'SqlElasticPool' OR [database_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_elastic_pool_target_database_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_elastic_pool_target_elastic_pool_name_not_null] CHECK  (([target_type]<>'SqlElasticPool' OR [elastic_pool_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_elastic_pool_target_elastic_pool_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_elastic_pool_target_refresh_credential_name_not_null] CHECK  (([target_type]<>'SqlElasticPool' OR [refresh_credential_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_elastic_pool_target_refresh_credential_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_elastic_pool_target_server_name_not_null] CHECK  (([target_type]<>'SqlElasticPool' OR [server_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_elastic_pool_target_server_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_server_target_database_name_null] CHECK  (([target_type]<>'SqlServer' OR [database_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_server_target_database_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_server_target_refresh_credential_name_not_null] CHECK  (([target_type]<>'SqlServer' OR [refresh_credential_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_server_target_refresh_credential_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_server_target_server_name_not_null] CHECK  (([target_type]<>'SqlServer' OR [server_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_server_target_server_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_shard_map_target_database_name_not_null] CHECK  (([target_type]<>'SqlShardMap' OR [database_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_shard_map_target_database_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_shard_map_target_refresh_credential_name_not_null] CHECK  (([target_type]<>'SqlShardMap' OR [refresh_credential_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_shard_map_target_refresh_credential_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_shard_map_target_server_name_not_null] CHECK  (([target_type]<>'SqlShardMap' OR [server_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_shard_map_target_server_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_sql_shard_map_target_shard_map_name_not_null] CHECK  (([target_type]<>'SqlShardMap' OR [shard_map_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_sql_shard_map_target_shard_map_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_database_name_null] CHECK  (([target_type]<>'TargetGroup' OR [database_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_database_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_name_exclusive_to_target_group] CHECK  (([target_group_name] IS NULL OR [target_type]='TargetGroup'))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_name_exclusive_to_target_group]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_refresh_credential_name_null] CHECK  (([target_type]<>'TargetGroup' OR [refresh_credential_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_refresh_credential_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_resource_group_name_null] CHECK  (([target_type]<>'TargetGroup' OR [resource_group_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_resource_group_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_server_name_null] CHECK  (([target_type]<>'TargetGroup' OR [server_name] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_server_name_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_subscription_id_null] CHECK  (([target_type]<>'TargetGroup' OR [subscription_id] IS NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_subscription_id_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_group_target_group_name_not_null] CHECK  (([target_type]<>'TargetGroup' OR [target_group_name] IS NOT NULL))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_group_target_group_name_not_null]
GO
ALTER TABLE [jobs_internal].[targets]  WITH CHECK ADD  CONSTRAINT [CK_target_type] CHECK  (([target_type]='SqlShardMap' OR [target_type]='SqlServer' OR [target_type]='SqlElasticPool' OR [target_type]='SqlDatabase' OR [target_type]='TargetGroup'))
GO
ALTER TABLE [jobs_internal].[targets] CHECK CONSTRAINT [CK_target_type]
GO
/****** Object:  StoredProcedure [dbo].[p_x]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[p_x]
as
begin
declare @t table(col1 varchar(10), col2 float, col3 float, col4 float)
insert @t values('a', 1,1,1)
insert @t values('b', 2,2,2)

select * from @t
end
GO
/****** Object:  StoredProcedure [dbo].[setVariables]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================*/
--PROCEDURE		: setVariables
--PURPOSE		: set all information of given JSON from the Customer Web Service
--INPUT PARAM	: @UserId @json
--EXECUTE
/*
	--Execute Procedure
	EXEC [dbo].[setVariables]  
		@UserId = 'user@domain.com', @Json= '{json structured file}'

*/
/*==================================================================================*/

CREATE PROCEDURE [dbo].[setVariables](@UserId varchar(50),@json varchar(max))
as

-- Local Variables
	DECLARE
	@ErrorCode INT;					-- Custom ErrorCode thrown by the SQL
	--declare @UserId varchar(50);
	--declare @json NVarchar(Max);
BEGIN

BEGIN TRY
	
	--verify JSON structure
	if (isjson(@json)=1)
	begin
	--Insert the values to the Variable table to insert the JSON file
	insert into UserData2.[Variable]
	SELECT VariableId,@UserId,[Values], case  when Unrestricted ='false' then 0 when Unrestricted ='true' then 1 end as Unrestricted  
	from OPENJSON(@json)

	WITH(
	Unrestricted Varchar(10) '$.unrestricted',
	Variables nvarchar(max) '$.variables' as JSON)
	CROSS APPLY OPENJSON(Variables) with (variableId varchar(50) '$.variableId'
										  ,[restrictedValues] nvarchar(max) '$.restrictedValues' as JSON )
									CROSS APPLY OPENJSON(restrictedValues) with ([Values] int '$')


	--FROM OPENROWSET (BULK @Path, SINGLE_CLOB) as JsonFile
	--CROSS APPLY OPENJSON(BulkColumn)
	end
	else
		RAISERROR ('The stream does not have a JSON structure, verify',15,217)

END TRY
BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE(), @ErrorCode = ISNULL(@ErrorCode, ERROR_NUMBER());

		-- Handle Custom Error
		IF(@ErrorCode >= 50000)
			THROW @ErrorCode, @ErrorMessage, @ErrorState;
		ELSE
			THROW;

END CATCH;	

END
GO
/****** Object:  StoredProcedure [dbo].[setVariablesFromFile]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==================================================================================*/
--PROCEDURE		: setVariables
--PURPOSE		: set all information of given JSON from the Customer Web Service
--INPUT PARAM	: @UserId @json
--EXECUTE
/*
	--Execute Procedure
	EXEC [dbo].[setVariables]  
		@UserId = 'user@domain.com', @Json= '{json structured file}'

*/
/*==================================================================================*/

CREATE PROCEDURE [dbo].[setVariablesFromFile](@UserId varchar(50),@FileNameJson varchar(max))
as

-- Local Variables
	DECLARE
	@ErrorCode INT;					-- Custom ErrorCode thrown by the SQL
	declare @sql Nvarchar(Max);
	declare @json NVarchar(Max);

BEGIN

BEGIN TRY
	
	--Recover content from the file into the Stream
	--SELECT @json = BulkColumn FROM OPENROWSET (BULK @FileNameJson, SINGLE_CLOB) AS j
	
		
	SET @sql = 'select @json = BulkColumn FROM OPENROWSET (BULK '''+@FileNameJson+''', SINGLE_CLOB) AS j' 

	EXEC sp_executesql @sql,N'@json NVARCHAR (MAX) OUTPUT',@json =@json OUTPUT;
					
	print @json;


	--Insert the values to the Variable table to insert the JSON file
	insert into UserData2.[Variable]
	SELECT VariableId,@UserId,[Values], case  when Unrestricted ='false' then 0 when Unrestricted ='true' then 1 end as Unrestricted  
	from OPENJSON(@json)

	WITH(
	Unrestricted Varchar(10) '$.unrestricted',
	Variables nvarchar(max) '$.variables' as JSON)
	CROSS APPLY OPENJSON(Variables) with (variableId varchar(50) '$.variableId'
										  ,[restrictedValues] nvarchar(max) '$.restrictedValues' as JSON )
									CROSS APPLY OPENJSON(restrictedValues) with ([Values] int '$')


	--FROM OPENROWSET (BULK @Path, SINGLE_CLOB) as JsonFile
	--CROSS APPLY OPENJSON(BulkColumn)

END TRY
BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE(), @ErrorCode = ISNULL(@ErrorCode, ERROR_NUMBER());

		-- Handle Custom Error
		IF(@ErrorCode >= 50000)
			THROW @ErrorCode, @ErrorMessage, @ErrorState;
		ELSE
			THROW;

END CATCH;	

END

GO



/****** Object:  StoredProcedure [dbo].[usp_request_range]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	08/02/2021
	usp_Range_Request
	---------------------
	Parameters
	ConfigurationID: uniqueIdentifier containing information from ScannerRange configuration
	date_UTC: date type configured with default value 01/01/1901
	range_size : bigint that contains the range size.
	
	Functionality:
	This SP serves to create a new range in case is a new scanner type based on the date
	
*/

CREATE PROCEDURE [dbo].[usp_request_range]
(@configurationID as uniqueidentifier,@date_utc as date,@range_size as bigint)
AS
	DECLARE @current_index as bigint;
	DECLARE @new_index as bigint;
	DECLARE @ErrorCode INT;		-- Custom ErrorCode thrown by the SQL
	DECLARE @start_Range as bigint;
	DECLARE @end_range as bigint;
	DECLARE @max_value as bigint;
	DECLARE @available as bigint;
BEGIN
	BEGIN TRY
		
		BEGIN TRAN;

		--Verify in Range table if exists
		SELECT @current_index=r.current_index
		FROM [dcnserver].[tbl_range] r WITH (rowlock,UpdLock)
		WHERE @date_utc=r.date_utc
		AND   @configurationID=r.configurationId;
		
		SET @max_value=1 ;
		

		IF (ISNULL(@current_index,-1)=-1) 
			BEGIN
			--if not exists then create a new row for the configuration	
											   
			--Set the Current Index value
			SET @new_index=@max_value +@range_size;
			--Set the current ranges values	
			SET @start_range=@max_value;
			SET @end_range=@max_value+@range_size-1;


			--inserts values to the tables		   			
			
			INSERT INTO dcnserver.tbl_range values (@date_utc,@configurationID,@new_index);
			
			
			END
		ELSE
			BEGIN
			--if exists then estimate the new range and current index
			--Calculate if range fits in actual range
				
				DECLARE @date_new_range as date;
				SELECT TOP 1 @start_range=u.start_range, @end_range=u.end_range,@date_new_range=date_utc
				FROM dcnserver.tbl_unused_range u WITH (rowlock,UpdLock)
				WHERE @configurationID=u.configurationId
				AND  u.date_utc=@date_utc
				AND  u.end_range-u.start_range >0
				ORDER BY u.date_utc,u.start_range desc
				;
				
				SET @available=@end_range- (@start_range+1);

				print cast(@available as varchar) +' '+ cast (@start_range as varchar) + ' ' + cast (@end_range as varchar)
				IF (@available > = @range_size) 
					BEGIN

					
					DECLARE @new_start_range  AS bigint;
					--setting the value for returning the start-end range for actual values
					SET @new_start_range=@start_range+@range_size;
					SET @end_range=@new_start_range;

					print 'case 2 '+cast(@new_start_range as varchar) + ' '+ cast(@start_range as varchar) + ' '+cast(@range_size as varchar)			
					--updating the start range value for the next run in table.
					UPDATE dcnserver.tbl_unused_range SET start_range=@new_start_range+1
					WHERE date_utc=@date_new_range
					AND   configurationId=@configurationID
					;
									
					END
				ELSE
					BEGIN 
					--Increase in ranges and update current index
					
					SET @start_range=@current_index;
					SET @end_range=@current_index+@range_size;

					print 'case 3 '+cast(@start_range as varchar) + ' '+ cast(@end_range as varchar) + ' '+cast(@current_index as varchar)
					UPDATE dcnserver.tbl_range SET current_index=@current_index+@range_size
					WHERE date_utc=@date_utc
					AND   configurationID=@configurationId
					;
					
					
					END
			
			END
			COMMIT TRAN;
			SELECT ISNULL(@start_range,0) as start_range,ISNULL(@end_range,0) as end_range;
			RETURN
			
		
	END TRY
	BEGIN CATCH

		ROLLBACK TRAN;
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE(), @ErrorCode = ISNULL(@ErrorCode, ERROR_NUMBER());

		-- Handle Custom Error
		IF(@ErrorCode >= 50000)
			THROW @ErrorCode, @ErrorMessage, @ErrorState;
		ELSE
			THROW;
	END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[usp_request_range2]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	08/02/2021
	usp_Range_Request
	---------------------
	Parameters
	range_type: String 255 containing information from ScannerRange configuration
	date_UTC: date type configured with default value 01/01/1901
	range_size : bigint that contains the range size.
	
	Functionality:
	This SP serves to create a new range in case is a new scanner type based on the date
	
*/

CREATE PROCEDURE [dbo].[usp_request_range2]
(@range_type as nvarchar(255),@date_utc as date,@range_size as bigint)
AS
	DECLARE @current_index as bigint;
	DECLARE @new_index as bigint;
	DECLARE @ErrorCode INT;		-- Custom ErrorCode thrown by the SQL
	DECLARE @start_Range as bigint;
	DECLARE @end_range as bigint;
	DECLARE @max_value as bigint;
	DECLARE @available as bigint;
BEGIN
	BEGIN TRY
		
		BEGIN TRAN;

		--Verify in Range table if exists
		SELECT @current_index=r.current_index
		FROM [dcnserver].[tbl_range] r WITH (rowlock,UpdLock)
		WHERE @date_utc=r.date_utc
		AND   @range_type=r.type;
		
		SET @max_value=1 ;
		print CAST (@current_index as varchar);

		IF (ISNULL(@current_index,-1)=-1) 
			BEGIN
			--if not exists then create a new row for the configuration	
											   
			--Set the Current Index value
			SET @new_index=@max_value +@range_size;
			--Set the current ranges values	
			SET @start_range=@max_value;
			SET @end_range=@max_value+@range_size-1;


			--inserts values to the tables		   			
			
			INSERT INTO dcnserver.tbl_range values (@date_utc,@range_type,@new_index);
			--INSERT INTO dcnserver.tbl_unused_range values (@range_type,@date_utc,@start_range,@end_range);
			COMMIT TRAN;
			END
		ELSE
			BEGIN
			--if exists then estimate the new range and current index
			--Calculate if range fits in actual range
				DECLARE @date_new_range as date;

				SELECT TOP 1 @start_range=u.start_range, @end_range=u.end_range
				FROM dcnserver.tbl_unused_range u WITH (rowlock,UpdLock)
				WHERE @range_type=u.type
				AND @date_utc=date_utc
				ORDER BY u.date_utc,u.start_range desc
				;

				--verify if range fits in the targeted date
	   			SET @available=@end_range- (@current_index+1);
				IF (@available > = @range_size) 
					BEGIN
					DECLARE @new_start_range  AS bigint;
					SET @new_start_range=@start_range+@range_size;
					
				
					UPDATE dcnserver.tbl_unused_range SET start_range=@new_start_range
					WHERE date_utc=@date_utc
					AND   type=@range_type
					;
									
					COMMIT TRAN;

					END
				ELSE
					BEGIN
						--search in the next available range date
					

						SELECT TOP 1 @start_range=u.start_range, @end_range=u.end_range,@date_new_range=date_utc
						FROM dcnserver.tbl_unused_range u WITH (rowlock,UpdLock)
						WHERE @range_type=u.type
						AND  u.end_range-(u.start_range+1) >0
						ORDER BY u.date_utc,u.start_range desc
						;
						
						IF(NOT ISNULL(@start_Range,-1)=-1)
							BEGIN
								print @range_type+'S= '+cast (@start_range as varchar)+' E='+cast(@end_range as varchar)+' D='+cast(@date_new_range as varchar);		
								--UPDATE dcnserver.tbl_unused_range SET start_range=@new_start_range
								--WHERE date_utc=@date_new_range
								--AND   type=@range_type
								;
									
								COMMIT TRAN;

							END
						ELSE
							BEGIN
							--not enough numbers on the requested date range
							
							RAISERROR('Range requested surpasses max cutoff',16,1);
							END
					
					END

			END

			SELECT ISNULL(@start_range,0) as start_range,ISNULL(@end_range,0) as end_range;
			RETURN
			
		
	END TRY
	BEGIN CATCH

		ROLLBACK TRAN;
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE(), @ErrorCode = ISNULL(@ErrorCode, ERROR_NUMBER());

		-- Handle Custom Error
		IF(@ErrorCode >= 50000)
			THROW @ErrorCode, @ErrorMessage, @ErrorState;
		ELSE
			THROW;
	END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[Usp_set_disk_Check]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Usp_set_disk_Check] as
begin
insert into dbo.Disk_Check
SELECT 
      db_name(a.database_id) AS [DB Name]
    , b.name AS [DB File Name]
    , a.file_id AS [File ID]
    , CASE WHEN a.file_id = 2 THEN 'Log' ELSE 'Data' END AS [DB File Type]
    , UPPER(SUBSTRING(b.physical_name, 1, 2)) AS [Disk Location] 
    , CASE WHEN a.num_of_reads < 1 THEN NULL ELSE CAST(a.io_stall_read_ms/(a.num_of_reads) AS INT) END AS [Avg Read Stall]
    , CASE 
        WHEN CASE WHEN a.num_of_reads < 1 THEN NULL ELSE CAST(a.io_stall_read_ms/(a.num_of_reads) AS INT) END < 10 THEN 'Very Good'
        WHEN CASE WHEN a.num_of_reads < 1 THEN NULL ELSE CAST(a.io_stall_read_ms/(a.num_of_reads) AS INT) END < 20 THEN 'OK'
        WHEN CASE WHEN a.num_of_reads < 1 THEN NULL ELSE CAST(a.io_stall_read_ms/(a.num_of_reads) AS INT) END < 50 THEN 'Slow, Needs Attention'
        WHEN CASE WHEN a.num_of_reads < 1 THEN NULL ELSE CAST(a.io_stall_read_ms/(a.num_of_reads) AS INT) END >= 50 THEN 'Serious I/O Bottleneck'
        END AS [Read Performance]
    , a.num_of_reads AS [Num Reads]
    , CASE WHEN a.num_of_writes < 1 THEN NULL ELSE CAST(a.io_stall_write_ms/a.num_of_writes AS INT) END AS [Avg_Write_Stall]
    , CASE 
        WHEN CASE WHEN a.num_of_writes < 1 THEN NULL ELSE CAST(a.io_stall_write_ms/(a.num_of_writes) AS INT) END < 10 THEN 'Very Good'
        WHEN CASE WHEN a.num_of_writes < 1 THEN NULL ELSE CAST(a.io_stall_write_ms/(a.num_of_writes) AS INT) END < 20 THEN 'OK'
        WHEN CASE WHEN a.num_of_writes < 1 THEN NULL ELSE CAST(a.io_stall_write_ms/(a.num_of_writes) AS INT) END < 50 THEN 'Slow, Needs Attention'
        WHEN CASE WHEN a.num_of_writes < 1 THEN NULL ELSE CAST(a.io_stall_write_ms/(a.num_of_writes) AS INT) END >= 50 THEN 'Serious I/O Bottleneck'
        END AS [Write Performance]
    , a.num_of_writes AS [Num Writes]
    , CAST(((a.size_on_disk_bytes/1024)/1024.0)/1024 AS DECIMAL(10,2)) AS [Size on Disk GB]
    ,getDate() as dateRec
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a 
JOIN sys.database_files b 
    ON a.file_id = b.file_id 
    AND a.database_id = db_id()
ORDER BY (a.num_of_reads + a.num_of_writes) DESC

end;
GO
/****** Object:  StoredProcedure [dbo].[usp_unused_put]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	08/02/2021
	usp_Unset_Put
	---------------------
	Parameters
	ConfigurationId: UniqueIdentifier containing information from ScannerRange configuration
	date_UTC: date type configured with default value 01/01/1901
	Unused Range Start : bigint that contains the range start.
	Unused Range End : bigint that contains the range end.
	Functionality:
	This SP serves to create a new range in case is a new scanner type based on the date
	
*/

CREATE PROCEDURE [dbo].[usp_unused_put]
(@configurationID as uniqueidentifier,@date_utc as date,@unused_range_start as bigint,@unused_range_end as bigint)
AS
DECLARE @ErrorCode as INT;
DECLARE @current_index as BIGINT;
DECLARE @start_range as BIGINT, @end_range as BIGINT;
BEGIN
	BEGIN TRY
		BEGIN TRAN;

		--1. Verify if the Range exists
		
		SELECT @current_index=current_index
		FROM [dcnserver].[tbl_range] WITH (rowlock,UpdLock)
		WHERE @date_utc=date_utc
		AND   @configurationID=configurationId;

		IF (not ISNULL(@current_index,-1)=-1)
			BEGIN
			--2. If exists fetch in Unused ranges  row
			--SELECT @start_range=start_range,@end_range=end_range
			--FROM [dcnserver],[tbl_unused_range]
			--WHERE date_utc=@date_utc
			--AND   type=@range_type;

					   							
				--inserting unused range
				INSERT INTO [dcnserver].[tbl_unused_range] VALUES (@configurationID,@date_utc,@unused_range_start,@unused_range_end);
				

				COMMIT TRAN;
			END
			
			
		ELSE
			BEGIN
			--record doesn't exist
			RAISERROR('Range requested does not exist',16,1);
			
			END
						
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN;
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), 
			@ErrorState = ERROR_STATE(), @ErrorCode = ISNULL(@ErrorCode, ERROR_NUMBER());

		-- Handle Custom Error
		IF(@ErrorCode >= 50000)
			THROW @ErrorCode, @ErrorMessage, @ErrorState;
		ELSE
			THROW;
	END CATCH
END
GO
/****** Object:  StoredProcedure [jobs].[sp_add_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_add_job]
    @job_name                           NVARCHAR(128),
    @description                        NVARCHAR(512) = '',
    @enabled                            BIT = 0,
    @schedule_interval_type             NVARCHAR(50) = 'Once',
    @schedule_interval_count            INT = 1,
    @schedule_start_time                DATETIME2 = '01/01/0001 00:00:00',
    @schedule_end_time                  DATETIME2 = '12/31/9999 11:59:59',
    @job_id                             UNIQUEIDENTIFIER = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    SET @job_id = NEWID()
    INSERT INTO [jobs_internal].jobs( 
        job_id, 
        name,
        delete_requested_time,
        last_job_execution_id,
        description,
        is_system,
        enabled,
        schedule_start_time,
        schedule_end_time,
        schedule_interval_type,
        schedule_interval_count
    ) VALUES ( 
        @job_id,
        @job_name,
        NULL,
        NULL,
        @description,
        0,
        @enabled,
        @schedule_start_time,
        @schedule_end_time,
        @schedule_interval_type,
        @schedule_interval_count
    )
END
GO
/****** Object:  StoredProcedure [jobs].[sp_add_jobstep]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_add_jobstep]
    @job_name                           NVARCHAR(128),
    @step_id                            INT = NULL OUTPUT,
    @step_name                          NVARCHAR(128) = NULL,
    @command_type                       NVARCHAR(50) = 'TSql',
    @command_source                     NVARCHAR(50) = 'Inline',
    @command                            NVARCHAR(MAX),
    @credential_name                    NVARCHAR(128),
    @target_group_name                  NVARCHAR(128),
    @initial_retry_interval_seconds     INT = 1,
    @maximum_retry_interval_seconds     INT = 120,
    @retry_interval_backoff_multiplier  REAL = 2.0,
    @retry_attempts                     INT = 10,
    @step_timeout_seconds               INT = 43200,
    @output_type                        NVARCHAR(50) = NULL,
    @output_credential_name             NVARCHAR(128) = NULL,
    @output_subscription_id             UNIQUEIDENTIFIER = NULL,
    @output_resource_group_name         NVARCHAR(128) = NULL,
    @output_server_name                 NVARCHAR(256) = NULL,
    @output_database_name               NVARCHAR(128) = NULL,
    @output_schema_name                 NVARCHAR(128) = NULL,
    @output_table_name                  NVARCHAR(128) = NULL,
    @job_version                        INT = NULL OUTPUT,
    @max_parallelism                    INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @error_message NVARCHAR(1000)

    -- Find job_id
    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    -- Insert new version into job_versions. This outputs the new version number.
    EXEC [jobs_internal].sp_add_job_version @job_id, @job_version OUTPUT

    -- Determine range of allowed step ids
    DECLARE @max_allowed_step_id INT
    SELECT @max_allowed_step_id = ISNULL(MAX(step_id), 0) + 1
    FROM [jobs].jobstep_versions
    WHERE job_id = @job_id
    AND job_version = @job_version - 1

    -- If @step_id is NULL, it means 'add a step to the end'
    IF @step_id IS NULL
    BEGIN
        SET @step_id = @max_allowed_step_id
    END

    -- Validate @step_id
    IF @step_id <= 0 OR @step_id > @max_allowed_step_id
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @step_id: ''%i''. @step_id must be greater than or equal to 1 and less than or equal to ''%i''.', @step_id, @max_allowed_step_id);
        THROW 50000, @error_message, 1
    END

    -- Validate @step_name nullness
    IF @step_name IS NULL
    BEGIN
        -- For step id 1 only, we make the API more convenient by providing a default step name.
        IF @step_id = 1
        BEGIN
            SET @step_name = 'JobStep'
        END
        ELSE
        BEGIN
            SET @error_message = FORMATMESSAGE('@step_name may only be NULL for the first job step.', @step_id);
            THROW 50000, @error_message, 1
        END
    END

    -- Validate @max_parallelism
    IF @max_parallelism IS NOT NULL AND @max_parallelism < 1
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @max_parallelism: ''%i''. @max_parallelism must be NULL or greater than or equal to 1.', @max_parallelism);
        THROW 50000, @error_message, 1
    END

    -- Validate @step_name uniqueness
    DECLARE @step_id_with_same_name INT
    SELECT @step_id_with_same_name = step_id
    FROM [jobs].jobstep_versions
    WHERE job_id = @job_id
    AND job_version = @job_version - 1
    AND step_name = @step_name

    IF @step_id_with_same_name IS NOT NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('A step with name ''%s'' (step id ''%i'') already exists for the job ''%s''.', @step_name, @step_id_with_same_name, @job_name);
        THROW 50000, @error_message, 1
    END

    -- Insert new data into jobstep_data
    DECLARE @jobstep_data_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_add_jobstep_data
        @command_type,
        @command_source,
        @command,
        @credential_name,
        @target_group_name,
        @initial_retry_interval_seconds,
        @maximum_retry_interval_seconds,
        @retry_interval_backoff_multiplier,
        @retry_attempts,
        @step_timeout_seconds,
        @output_type,
        @output_credential_name,
        @output_subscription_id,
        @output_resource_group_name,
        @output_server_name,
        @output_database_name,
        @output_schema_name,
        @output_table_name,
        @jobstep_data_id OUTPUT,
        @max_parallelism

    -- Insert new step into jobsteps that link the job_versions to the jobsteps
    -- We copy existing steps to ensure (with primary key) that we aren't overwriting a step with the same id
    -- Any existing steps with step_id >= the new step's id will be bumped up by 1.
    INSERT INTO [jobs_internal].jobsteps
    -- Select existing steps
    SELECT
        job_id,
        @job_version,
        -- If existing step is equal to or greater than the new step's id,
        -- then this existing step needs its id increased by 1 to make a gap
        -- to put the new step into
        step_id + IIF(step_id >= @step_id, 1, 0),
        jobstep_data_id,
        step_name
    FROM [jobs_internal].jobsteps
    WHERE job_id = @job_id AND job_version_number = @job_version - 1
        UNION ALL
    -- Select new step
    SELECT
        @job_id,
        @job_version,
        @step_id,
        @jobstep_data_id,
        @step_name

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_add_target_group]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_add_target_group]
    @target_group_name      NVARCHAR(128),
    @target_group_id        UNIQUEIDENTIFIER = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @error_message NVARCHAR(1000)

    -- Check if target group name already exists in targets --
    IF EXISTS(SELECT 1
              FROM [jobs_internal].visible_target_groups
              WHERE target_group_name = @target_group_name)
    BEGIN
        SET @error_message = FORMATMESSAGE('Target group ''%s'' already exists.', @target_group_name);
        THROW 50000, @error_message, 1
    END

    -- Concurrency plan: not needed, just fail with unique index violation if it already exists
    SET @target_group_id = NEWID()
    INSERT INTO [jobs_internal].targets (
        target_id,
        target_type,
        target_group_name
    ) VALUES (
        @target_group_id,
        'TargetGroup',
        @target_group_name
    )
END
GO
/****** Object:  StoredProcedure [jobs].[sp_add_target_group_member]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_add_target_group_member]
    @target_group_name          NVARCHAR(128),
    @membership_type            NVARCHAR(50) = 'Include',
    @target_type                NVARCHAR(50),
    @refresh_credential_name    NVARCHAR(128) = NULL,
    @server_name                NVARCHAR(128) = NULL,
    @database_name              NVARCHAR(128) = NULL,
    @elastic_pool_name          NVARCHAR(128) = NULL,
    @shard_map_name             NVARCHAR(128) = NULL,
    @target_id                  UNIQUEIDENTIFIER = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @error_message NVARCHAR(1000)

    -- Determine target group id
    DECLARE @target_group_id UNIQUEIDENTIFIER
    SET @target_group_id = (
        SELECT target_id
        FROM [jobs_internal].visible_target_groups
        WHERE target_group_name = @target_group_name
    )

    -- Check if target group id is in targets table --
    IF (@target_group_id IS NULL)
    BEGIN
        SET @error_message = FORMATMESSAGE('Target group ''%s'' does not exist.', @target_group_name);
        THROW 50000, @error_message, 1
    END

    -- Insert the single target into a table variable so we can pass it as a table-valued parameter
    DECLARE @input_targets [jobs_internal].target_group_members
    INSERT INTO @input_targets VALUES (
        @membership_type,
        @target_type,
        @refresh_credential_name,
        NULL, -- subscription_id
        NULL, -- resource_group_name
        @server_name,
        @database_name,
        @elastic_pool_name,
        @shard_map_name -- shard_map_name
    )

    -- INSERT into targets or SELECT it if a matching row exists.
    DECLARE @input_memberships TABLE (
        child_target_id UNIQUEIDENTIFIER PRIMARY KEY,
        include BIT NOT NULL -- NOT NULL to cause error when membership_type string is invalid
    )
    INSERT INTO @input_memberships
    EXEC [jobs_internal].sp_add_or_get_target_group_members @input_targets

    -- Note that @input_memberships should now have exactly 1 row

    -- Check if parent group id and child group id already exist in target group memberships
    DECLARE @existing_child_id NVARCHAR(1000) =  (SELECT TOP 1 CAST(im.child_target_id AS NVARCHAR(1000))
                                                  FROM @input_memberships im, [jobs_internal].target_group_memberships tgm
                                                  WHERE im.child_target_id = tgm.child_target_id AND
                                                        tgm.parent_target_id = @target_group_id);
    IF (@existing_child_id IS NOT NULL)
    BEGIN
        SET @error_message = FORMATMESSAGE('Target group member ''%s'' already belongs to ''%s''.', @existing_child_id, @target_group_name);
        THROW 50000, @error_message, 1
    END

    -- Insert into target_group_memberships
    INSERT INTO [jobs_internal].target_group_memberships
    SELECT
        @target_group_id as parent_target_id,
        child_target_id,
        include
    FROM @input_memberships

    SELECT @target_id = child_target_id
    FROM @input_memberships

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_delete_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_delete_job]
    @job_name           NVARCHAR(128),
    @force              BIT             = 0
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    -- Concurrency plan: acquire lock on row in first query
    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    -- Find active job executions for this job --
    DECLARE @active_job_execution_ids TABLE(job_execution_ids UNIQUEIDENTIFIER)
    INSERT INTO @active_job_execution_ids
    SELECT je.root_job_execution_id
    FROM [jobs_internal].[job_executions] je
    WHERE je.job_id = @job_id AND je.is_active = 1

    -- Check if active job executions --
    IF EXISTS(SELECT 1 FROM @active_job_execution_ids)
        IF (@force = 0)
            BEGIN
                THROW 50000, 'The job could not be deleted because there are active job executions. In order to force deletion of this job and cancel its active executions, specify `@force=1`.', 1
                RETURN
            END

        -- If force delete was requested --
        BEGIN
            -- Add each active job executions for this job to the job cancellations table --
            DECLARE @active_je_id UNIQUEIDENTIFIER
            DECLARE active_je_cursor CURSOR FOR SELECT * FROM @active_job_execution_ids

            OPEN active_je_cursor
            FETCH NEXT FROM active_je_cursor INTO @active_je_id

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    EXEC [jobs].[sp_stop_job] @active_je_id
                    PRINT 'Cancelled job execution with id ' + CAST(@active_je_id AS VARCHAR(128))
                    FETCH NEXT FROM active_je_cursor INTO @active_je_id
                END
            CLOSE active_je_cursor
            DEALLOCATE active_je_cursor
        END

    -- Mark the job as deleted --
    UPDATE [jobs_internal].jobs
    SET delete_requested_time = GETUTCDATE()
    WHERE job_id = @job_id

    -- Complete Transaction --
    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_delete_jobstep]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_delete_jobstep]
    @job_name               NVARCHAR(128),
    @step_id                INT = NULL,
    @step_name              NVARCHAR(120) = NULL,
    @job_version            INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @error_message NVARCHAR(1000)

    -- Find job_id
    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    -- Insert new version into job_versions. This outputs the new version number.
    EXEC [jobs_internal].sp_add_job_version @job_id, @job_version OUTPUT

    -- Find the step id (by step id or by step name) and verify it exists
    EXEC [jobs_internal].sp_find_jobstep @job_id, @job_version, @step_id OUTPUT, @step_name

    -- Insert new step into jobsteps that link the job_versions to the jobsteps
    -- We copy existing steps to ensure (with primary key) that we aren't overwriting a step with the same id
    INSERT INTO [jobs_internal].jobsteps
    -- Select non-deleted steps
    SELECT
        job_id,
        @job_version,
        -- If existing step is after the deleted step's id,
        -- then this existing step needs its id decreased by 1 to fill the hole
        step_id + IIF(step_id > @step_id, -1, 0),
        jobstep_data_id,
        step_name
    FROM [jobs_internal].jobsteps
    WHERE job_id = @job_id AND job_version_number = @job_version - 1 AND step_id <> @step_id

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_delete_target_group]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_delete_target_group]
    @target_group_name  NVARCHAR(128),
    @force              BIT = 0
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    BEGIN TRANSACTION

    -- Concurrency plan: acquire lock on row in first query

    -- Get the target group's id
    DECLARE @target_id UNIQUEIDENTIFIER
    SELECT @target_id = target_id
    FROM [jobs_internal].targets
    WITH (UPDLOCK, SERIALIZABLE, ROWLOCK)
    WHERE target_group_name = @target_group_name
      AND delete_requested_time IS NULL

    DECLARE @error_message NVARCHAR(1000)
    IF @target_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('The target group ''%s'' was not found.', @target_group_name);
        THROW 50000, @error_message, 1
    END

    -- Check for job steps using this target group
    DECLARE @job_name NVARCHAR(128)
    DECLARE @step_name NVARCHAR(128)
    DECLARE @step_id INT
    DECLARE @total_steps INT

    -- Select just 1 row, but also determine the total count of rows
    SELECT TOP (1)
        @job_name = job_name,
        @step_name = step_name,
        @total_steps = COUNT(*) OVER() -- trick to get total count of rows
    FROM jobs.jobsteps
    WHERE target_group_id = @target_id

    IF @total_steps > 0
    BEGIN
        SET @error_message = FORMATMESSAGE(
            'The target group ''%s'' cannot be deleted because it is referenced by job ''%s'' step ''%s'' and %i other job step(s).',
            @target_group_name,
            @job_name,
            @step_name,
            @total_steps - 1);
        THROW 50000, @error_message, 1
    END

    -- Check for active executions using this target group
    -- We can't just search the job_executions.taget_group_name column, because the step that uses the target group
    -- might not have begun executing. So we have to search target_group_name of all steps in the version that is
    -- being executed.
    DECLARE @job_execution_id UNIQUEIDENTIFIER
    DECLARE @job_version INT
    DECLARE @total_executions INT

    -- Select just 1 row, but also determine the total count of rows
    SELECT TOP (1)
        @job_execution_id = JE.job_execution_id,
        @job_name = JSV.job_name,
        @step_name = JSV.step_name,
        @total_executions = COUNT(*) OVER() -- trick to get total count of rows
    FROM jobs.job_executions JE
    INNER JOIN jobs.jobstep_versions JSV
        ON JE.job_id = JSV.job_id AND JE.job_version = JSV.job_version
    WHERE JSV.target_group_id = @target_id
      AND JE.is_active = 1

    IF @job_execution_id IS NOT NULL
    BEGIN
        SET @error_message = FORMATMESSAGE(
            'The target group ''%s'' cannot be deleted because it is referenced by active job execution ''%s'' (job ''%s'' step ''%s'') and %i other job executions.',
            @target_group_name,
            cast(@job_execution_id as char(36)),
            @job_name,
            @step_name,
            @total_executions - 1);
        THROW 50000, @error_message, 1
    END

    -- Mark the target group for cleanup
    UPDATE [jobs_internal].targets
    SET delete_requested_time = GETUTCDATE()
    WHERE target_id = @target_id

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_delete_target_group_member]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_delete_target_group_member]
    @target_group_name          NVARCHAR(128),
    @target_id                  UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DELETE mem
    FROM [jobs_internal].target_group_memberships mem
    INNER JOIN [jobs_internal].visible_target_groups tg
        ON mem.parent_target_id = tg.target_id
    WHERE tg.target_group_name = @target_group_name
    AND mem.child_target_id = @target_id

    -- Ensure that we deleted exactly one row
    IF (@@ROWCOUNT <> 1)
    BEGIN
        DECLARE @error_message NVARCHAR(1000) = FORMATMESSAGE('Target with target_id ''%s'' was not found as a member of target group ''%s''', CAST(@target_id AS NCHAR(36)),@target_group_name);
        THROW 50000, @error_message, 1
    END

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_purge_jobhistory]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_purge_jobhistory]
    @job_name       NVARCHAR(128) = NULL,
    @job_id         UNIQUEIDENTIFIER = NULL,
    @oldest_date    DATETIME2 = NULL
AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @error_message NVARCHAR(1000)

-- If we were given job_name, determine job_id
IF @job_name IS NOT NULL
BEGIN
    -- Assert that job_id is NULL, because job_id and job_name cannot both be provided
    IF @job_id IS NOT NULL
    BEGIN
        SET @error_message = '@job_name and @job_id parameters cannot both be specified';
        THROW 50000, @error_message, 1
    END

    -- Get the job with that id
    SELECT @job_id = job_id
    FROM [jobs_internal].visible_jobs
    WHERE name = @job_name

    -- Assert that job_id is NOT NULL
    IF @job_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('Job ''%s'' was not found', @job_name);
        THROW 50000, @error_message, 1
    END
END
ELSE
BEGIN
    -- Assert that job_id is NOT NULL. 
    -- For now due to safety concerns we don't allow 'purge all' semantics like Sql Agent does.
    IF @job_id IS NULL
    BEGIN
        SET @error_message = '@job_name or @job_id (and not both) must be specified.';
        THROW 50000, @error_message, 1
    END
END

-- Devnote: columns below denote which table they come from (je_job_execution_id came from JobExecution table).
-- this is helpful to know since we use outer joins
DECLARE @pending_deletes TABLE(
    je_job_execution_id UNIQUEIDENTIFIER NULL,
    jte_job_task_execution_id UNIQUEIDENTIFIER NULL
)

DECLARE @did_work bit = 1;
DECLARE @loop_number int = 0;
DECLARE @rows_affected int;
WHILE (@did_work = 1)
BEGIN
    SET @loop_number = @loop_number + 1;
    SET @did_work = 0;

    DELETE FROM @pending_deletes;

    -- Devnote: Left joins below are critical for performance. The goal is to get up to 10000 rows quickly,
    -- no matter which table supplies the values. E.g. if are rows in JobTaskExecution, fine, we'll work on them,
    -- but if there aren't - also fine, we'll get to delete rows from JobExecution
    -- Devnote: it may take several passes to purge - first JobTaskExecutions, then JobExecutions.
    -- That is Ok because below query is relatively cheap.

    INSERT INTO @pending_deletes
    SELECT TOP 2000
        JE.job_execution_id,
        JTE.job_task_execution_id
    FROM
        [jobs_internal].job_executions JE
        LEFT OUTER JOIN [jobs_internal].job_task_executions JTE
            ON JTE.job_execution_id = JE.job_execution_id
        -- Enables check on parent job execution below
        LEFT OUTER JOIN [jobs_internal].job_executions ParentJE
            ON ParentJE.job_execution_id = JE.parent_job_execution_id
    WHERE 
        -- If @job_id was specified, filter by that job id
        (@job_id IS NULL OR JE.job_id = @job_id)
        -- If @oldest_date was specified, only delete job executions that ended before then
        AND (@oldest_date IS NULL OR JE.end_time < @oldest_date)
        -- Only delete inactive job executions
        AND JE.is_active = 0
        -- If there is a parent job execution, it needs to be finished.
        AND (ParentJE.lifecycle IS NULL OR ParentJE.is_active = 0)
        -- There are no child job executions (it takes two passes to delete parent job execution)
        AND NOT EXISTS (
            SELECT *
            FROM [jobs_internal].job_executions ChildJE
            WHERE ChildJE.parent_job_execution_id = JE.job_execution_id
        )
    SET @rows_affected = @@ROWCOUNT;
    IF(@rows_affected = 0)
    BEGIN
        -- There are no rows to clean up
        BREAK;
    END

    /*
    Due to self-references, it's easier to delete all JobTaskExecutions for any given JobExecution.
    So if at least one JobTaskExecution exists, we delete all JobTaskExecutions with the same JobExecution
    Devnote: we're not checking for lifecycle of JobTaskExecutions because they belong to JobExecutions which 
    are already in terminal state.
    */

    -- Level 2: JobTaskExecution

    -- a) free JobTaskExecutions we're trying to delete from reference by JobExecution
    UPDATE JE
        SET JE.last_job_task_execution_id = NULL
    FROM
        @pending_deletes del 
        INNER JOIN [jobs_internal].job_executions JE 
            ON del.je_job_execution_id = JE.job_execution_id
    WHERE
        -- Appropriate level: We have JobExecution and JobTaskExecution. 
        -- (JobExecution may have reference to JobTaskExecution we're trying to delete)
        del.je_job_execution_id IS NOT NULL AND
        del.jte_job_task_execution_id IS NOT NULL AND

        -- Only clear reference where it exists
        JE.last_job_task_execution_id IS NOT NULL

    SET @rows_affected = @@ROWCOUNT
    IF @rows_affected > 0 SET @did_work = 1

    -- b) delete
    ;WITH unique_job_executions AS
    (
        SELECT DISTINCT je_job_execution_id
        FROM @pending_deletes
        WHERE jte_job_task_execution_id IS NOT NULL
    )
    DELETE JTE
    FROM
        unique_job_executions JE 
        INNER JOIN [jobs_internal].job_task_executions JTE 
            ON JE.je_job_execution_id = JTE.job_execution_id

    SET @rows_affected = @@ROWCOUNT
    IF @rows_affected > 0 SET @did_work = 1

    -- Level 1: JobExecution

    -- a) Cancellations
    DELETE JC
    FROM
        @pending_deletes del
        INNER JOIN [jobs_internal].job_cancellations JC
            ON del.je_job_execution_id = JC.job_execution_id

    SET @rows_affected = @@ROWCOUNT
    IF @rows_affected > 0 SET @did_work = 1
    
    -- b) Disentanglement, make sure Jobs do not point to JobExecutions to be deleted
    UPDATE J
        SET J.last_job_execution_id = NULL
    FROM
        @pending_deletes del
        INNER JOIN [jobs_internal].jobs J
            ON (@job_id IS NULL OR @job_id = J.job_id)
            AND del.je_job_execution_id = J.last_job_execution_id
    WHERE 
        J.last_job_execution_id IS NOT NULL
        -- Only disentangle the last job execution for tombstoned jobs, because last job execution affects scheduling
        -- (if there is no last job execution in a certain time range then the scheduler will schedule a new execution)
        -- and we don't want to break scheduling of non-tombstoned jobs
        AND J.delete_requested_time IS NOT NULL

    SET @rows_affected = @@ROWCOUNT
    IF @rows_affected > 0 SET @did_work = 1

    DELETE JE
    FROM
        @pending_deletes del
        INNER JOIN [jobs_internal].job_executions JE
            ON del.je_job_execution_id = JE.job_execution_id
    WHERE
        -- Appropriate level: We have JobExecution, but not JobTaskExecution
        -- Devnote: Q: we just deleted JobTaskExecutions, why can't we just delete JobExecution now? 
        -- A: we deleted a batch of them, there may be more.
        -- So only when we know that there were no JobTaskExecutions, it is safe to delete JobExecution.
        del.je_job_execution_id IS NOT NULL
        AND del.jte_job_task_execution_id IS NULL
        -- Do not delete the last job execution for non-tombstoned jobs, because last job execution affects scheduling
        -- At this point we can't delete them anyway due to foreign key that we intentionally didn't disentangle earlier
        AND JE.job_execution_id NOT IN (
            SELECT last_job_execution_id
            FROM [jobs_internal].visible_jobs
            -- This next line is important, otherwise a row with NULL value for last_job_execution_id would cause
            -- the entire NOT IN to evaluate to UNKNOWN, so no job executions would ever be deleted
            WHERE last_job_execution_id IS NOT NULL
        )

    SET @rows_affected = @@ROWCOUNT
    IF @rows_affected > 0 SET @did_work = 1

    WAITFOR DELAY '00:00:00.500'
END
END
GO
/****** Object:  StoredProcedure [jobs].[sp_start_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [jobs].[sp_start_job]
    @job_name           NVARCHAR(128),
    @job_execution_id   UNIQUEIDENTIFIER = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    DECLARE @error_message NVARCHAR(1000)
    IF @job_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('Job ''%s'' was not found.', @job_name);
        THROW 50000, @error_message, 1
    END

    -- Determine job version number
    DECLARE @job_version INT
    SELECT @job_version = current_job_version_number
    FROM [jobs_internal].current_job_version_numbers
    WHERE job_id = @job_id

    IF NOT EXISTS(
        SELECT * FROM [jobs].jobsteps JS
        WHERE JS.job_name = @job_name
        AND JS.job_version = @job_version)
    BEGIN
        SET @error_message = FORMATMESSAGE('Job ''%s'' contains no steps.', @job_name);
        THROW 50000, @error_message, 1
    END

    IF @job_execution_id IS NOT NULL
    BEGIN
        IF EXISTS(
            SELECT * from [jobs].job_executions
            WHERE job_execution_id = @job_execution_id)
        BEGIN
            DECLARE @id_error_message NVARCHAR(1000) = FORMATMESSAGE('Job Execution with id ''%s'' already exists.', convert(nvarchar(50), @job_execution_id));
            THROW 50000, @id_error_message, 1
        END
    END

    SET @job_execution_id = ISNULL(@job_execution_id, NEWID())
    INSERT INTO [jobs_internal].job_executions (
        job_execution_id,
        job_id,
        job_version_number,
        step_id,
        create_time,
        start_time,
        end_time,
        infrastructure_failures,
        current_task_attempts,
        next_retry_delay_ms,
        lifecycle,
        is_active,
        target_id,
        parent_job_execution_id,
        root_job_execution_id,
        initiated_for_schedule_time
    ) VALUES (
        @job_execution_id,
        @job_id,
        @job_version,
        NULL,
        GETUTCDATE(),
        NULL,
        NULL,
        0,
        0,
        0,
        'Created',
        1,
        NULL,
        NULL,
        @job_execution_id,
        NULL
    )

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_stop_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_stop_job]
    @job_execution_id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    -- Concurrency plan: acquire lock on JobCancellation.JobExecutionId in first query

    IF NOT EXISTS ( 
        SELECT 1 
        FROM [jobs_internal].job_cancellations
        WITH (UPDLOCK, SERIALIZABLE, ROWLOCK) 
        WHERE job_execution_id = @job_execution_id 
    )
    BEGIN
        INSERT INTO [jobs_internal].job_cancellations ( 
            job_execution_id, 
            requested_time 
        ) VALUES ( 
            @job_execution_id, 
            SYSUTCDATETIME() 
        )
    END
END
GO
/****** Object:  StoredProcedure [jobs].[sp_update_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_update_job]
    @job_name                           NVARCHAR(128),
    @new_name                           NVARCHAR(128) = NULL,
    @description                        NVARCHAR(512) = NULL,
    @enabled                            BIT = NULL,
    @schedule_interval_type             NVARCHAR(50) = NULL,
    @schedule_interval_count            INT = NULL,
    @schedule_start_time                DATETIME2 = NULL,
    @schedule_end_time                  DATETIME2 = NULL
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    UPDATE [jobs_internal].jobs
    SET 
        name = ISNULL(@new_name, name),
        description = ISNULL(@description, description),
        enabled = ISNULL(@enabled, enabled),
        schedule_start_time = ISNULL(@schedule_start_time, schedule_start_time),
        schedule_end_time = ISNULL(@schedule_end_time, schedule_end_time),
        schedule_interval_type = ISNULL(@schedule_interval_type, schedule_interval_type),
        schedule_interval_count = ISNULL(@schedule_interval_count, schedule_interval_count)
    WHERE job_id = @job_id

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs].[sp_update_jobstep]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs].[sp_update_jobstep]
    @job_name                           NVARCHAR(128),
    @step_id                            INT = NULL,
    @step_name                          NVARCHAR(128) = NULL,
    @new_id                             INT = NULL,
    @new_name                           NVARCHAR(128) = NULL,
    @command_type                       NVARCHAR(50) = NULL,
    @command_source                     NVARCHAR(50) = NULL,
    @command                            NVARCHAR(MAX) = NULL,
    @credential_name                    NVARCHAR(128) = NULL,
    @target_group_name                  NVARCHAR(128) = NULL,
    @initial_retry_interval_seconds     INT = NULL,
    @maximum_retry_interval_seconds     INT = NULL,
    @retry_interval_backoff_multiplier  REAL = NULL,
    @retry_attempts                     INT = NULL,
    @step_timeout_seconds               INT = NULL,
    @output_type                        NVARCHAR(50) = NULL,
    @output_credential_name             NVARCHAR(128) = NULL,
    @output_server_name                 NVARCHAR(256) = NULL,
    @output_subscription_id             UNIQUEIDENTIFIER = NULL,
    @output_resource_group_name         NVARCHAR(128) = NULL,
    @output_database_name               NVARCHAR(128) = NULL,
    @output_schema_name                 NVARCHAR(128) = NULL,
    @output_table_name                  NVARCHAR(128) = NULL,
    @job_version                        INT = NULL OUTPUT,
    @max_parallelism                    INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @error_message NVARCHAR(1000)

    -- Find job_id
    DECLARE @job_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_lock_job @job_name, @job_id OUTPUT

    -- Insert new version into job_versions. This outputs the new version number.
    EXEC [jobs_internal].sp_add_job_version @job_id, @job_version OUTPUT

    -- Find the step id (by step id or by step name) and verify it exists
    EXEC [jobs_internal].sp_find_jobstep @job_id, @job_version, @step_id OUTPUT, @step_name

    -- Determine range of allowed step ids
    DECLARE @max_allowed_step_id INT
    SELECT @max_allowed_step_id = ISNULL(MAX(step_id), 1)
    FROM [jobs].jobstep_versions
    WHERE job_id = @job_id
    AND job_version = @job_version - 1

    -- Validate @new_id
    IF @new_id <= 0 OR @new_id > @max_allowed_step_id
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @new_id: ''%i''. @new_id must be greater than or equal to 1 and less than or equal to ''%i''.', @new_id, @max_allowed_step_id);
        THROW 50000, @error_message, 1
    END

    -- Validate @new_name uniqueness
    IF @new_name IS NOT NULL
    BEGIN
        DECLARE @step_id_with_same_name INT
        SELECT @step_id_with_same_name = step_id
        FROM [jobs].jobstep_versions
        WHERE job_id = @job_id
        AND job_version = @job_version - 1
        AND step_name = @new_name

        IF @step_id_with_same_name IS NOT NULL
        BEGIN
            SET @error_message = FORMATMESSAGE('A step with name ''%s'' (step id ''%i'') already exists for the job ''%s''.', @new_name, @step_id_with_same_name, @job_name);
            THROW 50000, @error_message, 1
        END
    END

    -- Validate @max_parallelism
    IF @max_parallelism IS NOT NULL AND (@max_parallelism = 0 or @max_parallelism < -1)
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @max_parallelism: ''%i''. @max_parallelism must be NULL (indicating no change), -1 (meaning that it will be set to NULL), or greater than or equal to 1.', @max_parallelism);
        THROW 50000, @error_message, 1
    END

    -- If any parameters were null, then set them to the jobstep's current value (so the field does not change)
    --
    -- For output fields (which, unlike all other jobstep fields, are nullable),
    -- '' param value means 'set the field to null', and null param value still means 'leave it unchanged'
    --
    -- For max parallelism (which is also nullable), -1 means 'set the field to null', and null param value
    -- means 'leave it unchanged'.
    SELECT
        @new_id = ISNULL(@new_id, step_id),
        @new_name = ISNULL(@new_name, step_name),
        @command_type = ISNULL(@command_type, command_type),
        @command_source = ISNULL(@command_source, command_source),
        @command = ISNULL(@command, command),
        @credential_name = ISNULL(@credential_name, credential_name),
        @target_group_name = ISNULL(@target_group_name, target_group_name),
        @initial_retry_interval_seconds = ISNULL(@initial_retry_interval_seconds, initial_retry_interval_seconds),
        @maximum_retry_interval_seconds = ISNULL(@maximum_retry_interval_seconds, maximum_retry_interval_seconds),
        @retry_interval_backoff_multiplier = ISNULL(@retry_interval_backoff_multiplier, retry_interval_backoff_multiplier),
        @retry_attempts = ISNULL(@retry_attempts, retry_attempts),
        @step_timeout_seconds = ISNULL(@step_timeout_seconds, step_timeout_seconds),
        @output_type = CASE @output_type
            WHEN '' THEN NULL
            ELSE ISNULL(@output_type, output_type) END,
        @output_credential_name = CASE @output_credential_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_credential_name, output_credential_name) END,
        @output_subscription_id = CASE @output_subscription_id
            WHEN '00000000-0000-0000-0000-000000000000' THEN NULL
            ELSE ISNULL(@output_subscription_id, output_subscription_id) END,
        @output_resource_group_name = CASE @output_resource_group_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_resource_group_name, output_resource_group_name) END,
        @output_server_name = CASE @output_server_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_server_name, output_server_name) END,
        @output_database_name = CASE @output_database_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_database_name, output_database_name) END,
        @output_schema_name = CASE @output_schema_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_schema_name, output_schema_name) END,
        @output_table_name = CASE @output_table_name
            WHEN '' THEN NULL
            ELSE ISNULL(@output_table_name, output_table_name) END,
        @max_parallelism = CASE @max_parallelism
            WHEN -1 then NULL
            ELSE ISNULL(@max_parallelism, max_parallelism) END
    FROM [jobs].jobstep_versions JS
    WHERE JS.job_id = @job_id
    AND JS.job_version = @job_version - 1
    AND JS.step_id = @step_id

    -- Insert new data into jobstep_data
    DECLARE @jobstep_data_id UNIQUEIDENTIFIER
    EXEC [jobs_internal].sp_add_jobstep_data
        @command_type,
        @command_source,
        @command,
        @credential_name,
        @target_group_name,
        @initial_retry_interval_seconds,
        @maximum_retry_interval_seconds,
        @retry_interval_backoff_multiplier,
        @retry_attempts,
        @step_timeout_seconds,
        @output_type,
        @output_credential_name,
        @output_subscription_id,
        @output_resource_group_name,
        @output_server_name,
        @output_database_name,
        @output_schema_name,
        @output_table_name,
        @jobstep_data_id OUTPUT,
        @max_parallelism

    -- Insert new step into jobsteps that link the job_versions to the jobsteps
    -- We copy existing steps to ensure (with primary key) that we aren't overwriting a step with the same id
    INSERT INTO [jobs_internal].jobsteps
    -- Select non-updated steps
    SELECT
        job_id,
        @job_version,
        CASE
            -- Non-updated step is both before both the updated step's old & new id: no change
            WHEN step_id < @step_id AND step_id < @new_id THEN step_id

            -- Non-updated step is after the updated step's old id but before or equal
            -- to the updated step's new id: slide down 1
            -- This case will only happen if @step_id < @new_id, i.e.
            -- the updated step is being moved to later - in this case, the non-updated
            -- steps in between need to slide down to fill the gap left by
            -- the old step id and make a gap for the new step id
            WHEN @step_id < step_id AND step_id <= @new_id THEN step_id - 1

            -- Non-updated step is after the updated step's news id but before or equal
            -- to the updated step's old id: slide down 1
            -- This case will only happen if @new_id < @step_id , i.e.
            -- the updated step is being moved to earlier - in this case, the non-updated
            -- steps in between need to slide up to fill the gap left by
            -- the old step id and make a gap for the new step id
            WHEN @new_id <= step_id AND step_id < @step_id THEN step_id + 1

            -- After both old & new id: no change
            WHEN @step_id < step_id AND @new_id < step_id THEN step_id

            -- 'ELSE' should never happen, if it does then the value of this expression
            -- will be null and the insert should receive a null value error
        END,
        jobstep_data_id,
        step_name
    FROM [jobs_internal].jobsteps
    WHERE job_id = @job_id AND job_version_number = @job_version - 1 AND step_id <> @step_id
        UNION ALL
    -- Select updated step
    SELECT
        @job_id,
        @job_version,
        @new_id,
        @jobstep_data_id,
        @new_name

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_add_job_version]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_add_job_version]
    @job_id             UNIQUEIDENTIFIER,
    @job_version_number INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    SELECT @job_version_number = ISNULL(MAX(job_version_number), 0) + 1
        FROM [jobs_internal].job_versions
        WHERE job_id = @job_id

    INSERT INTO [jobs_internal].job_versions (
        job_id,
        job_version_number
    ) VALUES (
        @job_id,
        @job_version_number
    )

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_add_jobstep_data]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [jobs_internal].[sp_add_jobstep_data]
    @command_type                       NVARCHAR(50),
    @command_source                     NVARCHAR(50),
    @command                            NVARCHAR(MAX),
    @credential_name                    NVARCHAR(128),
    @target_group_name                  NVARCHAR(128),
    @initial_retry_interval_seconds     INT,
    @maximum_retry_interval_seconds     INT,
    @retry_interval_backoff_multiplier  REAL,
    @retry_attempts                     INT,
    @step_timeout_seconds               INT,
    @output_type                        NVARCHAR(50),
    @output_credential_name             NVARCHAR(128),
    @output_subscription_id             UNIQUEIDENTIFIER,
    @output_resource_group_name         NVARCHAR(128),
    @output_server_name                 NVARCHAR(256),
    @output_database_name               NVARCHAR(128),
    @output_schema_name                 NVARCHAR(128),
    @output_table_name                  NVARCHAR(128),
    @jobstep_data_id                    UNIQUEIDENTIFIER OUTPUT,
    @max_parallelism                    INT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    DECLARE @error_message NVARCHAR(1000)

    -- Validate parameters
    -- Need to manually validate @command_source since it isn't actually stored so we have no constraints in physical tables
    IF @command_source <> 'Inline'
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @command_source: ''%s''', @command_source);
        THROW 50000, @error_message, 1
    END
    IF @output_type IS NOT NULL AND @output_type <> 'SqlDatabase'
    BEGIN
        SET @error_message = FORMATMESSAGE('Invalid value for @output_type: ''%s''. Only NULL or ''SqlDatabase'' are supported.', @output_type);
        THROW 50000, @error_message, 1
    END

    -- Insert into CommandData
    DECLARE @command_data_id UNIQUEIDENTIFIER
    -- Try to find an existing command data that matches. Optimize by searching with checksum.
    -- In case of earlier bug where duplicate was inserted, select top 1 instead of all
    -- BINARY_CHECKSUM is not a great checksum function, for example it seems to produce the
    -- same results when trailing whitespace is added. Also we want to look for an exact
    -- binary match regardless of the db's collation (which might be whitespace/accent/case
    -- insensitive).
    SET @command_data_id = (
        SELECT TOP 1 command_data_id
        FROM [jobs_internal].command_data
        WHERE text_checksum = BINARY_CHECKSUM(@command)
        AND CAST(text AS VARBINARY(MAX)) = CAST(@command AS VARBINARY(MAX))
    )
    IF @command_data_id IS NULL
    BEGIN
        -- Matching command data was not found, so insert a new one.
        SET @command_data_id = NEWID()
        INSERT INTO [jobs_internal].command_data (
            command_data_id,
            script_has_been_split,
            text
        ) VALUES (
            @command_data_id,
            0,
            @command
        )
    END

    -- Determine TargetId
    DECLARE @target_id UNIQUEIDENTIFIER
    SET @target_id = (
        SELECT target_id
        FROM [jobs_internal].visible_target_groups
        WHERE target_group_name = @target_group_name
    )
    IF @target_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('Target Group ''%s'' not found', @target_group_name);
        THROW 50000, @error_message, 1
    END

    -- Check credential can be referenced
    IF ISNULL([jobs_internal].fn_has_credential_perms(@credential_name), 0) = 0
    BEGIN
        SET @error_message = FORMATMESSAGE('Cannot reference the credential ''%s'', because it does not exist or you do not have permission.', @credential_name);
        THROW 50000, @error_message, 1
    END

    -- Add or get output target and get output credential
    DECLARE @output_target_id UNIQUEIDENTIFIER
    DECLARE @output_credential_id INT
    IF @output_type IS NOT NULL
    BEGIN
        -- TODO: can we combine this logic with the add taget group member logic to reduce duplication?
        SET @output_target_id = (
            SELECT target_id
            FROM [jobs_internal].targets
            WHERE target_type = 'SqlDatabase'
              AND ((subscription_id IS NULL AND @output_subscription_id IS NULL) OR subscription_id = @output_subscription_id)
              AND ((resource_group_name IS NULL AND @output_resource_group_name IS NULL) OR resource_group_name = @output_resource_group_name)
              AND elastic_pool_name IS NULL
              AND server_name = @output_server_name
              AND database_name = @output_database_name
        )
        IF @output_target_id IS NULL
        BEGIN
            SET @output_target_id = NEWID()
            INSERT INTO [jobs_internal].targets (
                target_id,
                target_type,
                subscription_id,
                resource_group_name,
                server_name,
                database_name
            ) VALUES (
                @output_target_id,
                'SqlDatabase',
                @output_subscription_id,
                @output_resource_group_name,
                @output_server_name,
                @output_database_name
            )
        END

        -- Check credential can be referenced
        IF ISNULL([jobs_internal].fn_has_credential_perms(@output_credential_name), 0) = 0
        BEGIN
            SET @error_message = FORMATMESSAGE('Cannot reference the credential ''%s'', because it does not exist or you do not have permission.', @output_credential_name);
            THROW 50000, @error_message, 1
        END
    END

    -- Insert into JobStepData
    SET @jobstep_data_id = NEWID()
    INSERT INTO [jobs_internal].jobstep_data
    SELECT
        @jobstep_data_id,
        @command_type,
        @output_target_id,
        @output_credential_name,
        CASE
            WHEN @output_type IS NULL          THEN NULL
            WHEN @output_schema_name IS NULL   THEN 'dbo'
            ELSE                               @output_schema_name
        END,
        @output_table_name,
        @command_data_id,
        @credential_name,
        @target_id,
        @initial_retry_interval_seconds * 1000,
        @maximum_retry_interval_seconds * 1000,
        @retry_interval_backoff_multiplier,
        @retry_attempts,
        @step_timeout_seconds * 1000,
        @max_parallelism

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_add_or_get_target_group_members]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_add_or_get_target_group_members]
    @target_group_members   [jobs_internal].target_group_members READONLY
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    DECLARE @error_message NVARCHAR(1000)

    DECLARE @invalid_target_type NVARCHAR(900) = (SELECT TOP 1 target_type
                                                  FROM @target_group_members
                                                  WHERE target_type NOT IN ('SqlDatabase',
                                                                            'SqlElasticPool',
                                                                            'SqlServer',
                                                                            'SqlShardMap'));
    -- Checks that the target types are all valid --
    IF (@invalid_target_type IS NOT NULL)
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''%s'' is invalid.', @invalid_target_type);
        THROW 50000, @error_message, 1
    END

    -- SqlDatabase Required Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlDatabase' AND
                    (server_name IS NULL OR database_name IS NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlDatabase'' requires server name and database name properties to be specified.');
        THROW 50000, @error_message, 1
    END

    -- SqlDatabase Forbidden Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlDatabase' AND
                    (refresh_credential_name IS NOT NULL
                     OR elastic_pool_name IS NOT NULL
                     OR shard_map_name IS NOT NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlDatabase'' does not support the refresh credential, elastic pool name, or shard map name property.');
        THROW 50000, @error_message, 1
    END

    -- SqlServer Required Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlServer' AND
                    (server_name IS NULL OR refresh_credential_name IS NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlServer'' requires server name and refresh credential name properties to be specified.');
        THROW 50000, @error_message, 1
    END

    -- SqlServer Forbidden Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlServer' AND
                    (database_name IS NOT NULL
                     OR elastic_pool_name IS NOT NULL
                     OR shard_map_name IS NOT NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlServer'' does not support the database name, elastic pool name, or shard map name property.');
        THROW 50000, @error_message, 1
    END

    -- SqlElasticPool Required Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlElasticPool' AND
                    (server_name IS NULL OR elastic_pool_name IS NULL OR refresh_credential_name IS NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlElasticPool'' requires server name, elastic pool name, and refresh credential name properties to be specified.');
        THROW 50000, @error_message, 1
    END

    -- SqlElasticPool Forbidden Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlElasticPool' AND
                    (database_name IS NOT NULL
                     OR shard_map_name IS NOT NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlElasticPool'' does not support the database name or shard map name property.');
        THROW 50000, @error_message, 1
    END

    -- SqlShardMap Required Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlShardMap' AND
                    (server_name IS NULL OR database_name IS NULL OR shard_map_name IS NULL OR refresh_credential_name IS NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlShardMap'' requires server name, database name, shard map name, and refresh credential name properties to be specified.');
        THROW 50000, @error_message, 1
    END

    -- SqlShardMap Forbidden Parameters --
    IF EXISTS(SELECT 1
              FROM @target_group_members
              WHERE target_type = 'SqlShardMap' AND
                    (elastic_pool_name IS NOT NULL))
    BEGIN
        SET @error_message = FORMATMESSAGE('Target type ''SqlShardMap'' does not support the elastic pool name property.');
        THROW 50000, @error_message, 1
    END

    -- Verify that all credentials can be referenced
    DECLARE @forbidden_credentials NVARCHAR(900)

    SELECT @forbidden_credentials = COALESCE(@forbidden_credentials + ', ', '') + refresh_credential_name
    FROM @target_group_members
    WHERE [jobs_internal].fn_has_credential_perms(refresh_credential_name) = 0

    IF @forbidden_credentials IS NOT NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('Cannot reference the credential(s) ''%s'', because they do not exist or you do not have permission.', @forbidden_credentials);
        THROW 50000, @error_message, 1
    END

    -- Dummy variable to help with merge output
    DECLARE @WasUpdated BIT

    -- For each target in @input_targets, INSERT it into targets or SELECT it if a matching row exists.
    -- By design we never UPDATE, because targets are considered to be immutable values.
    -- Treating targets as immutable means we avoid bugs where modifying members of one target group
    -- accidentally affects the members of another target group.
    MERGE INTO [jobs_internal].targets existing_targets
    USING (
        SELECT
            t.*,
            CASE t.membership_type
                WHEN 'Include' THEN CAST(1 AS BIT)
                WHEN 'Exclude' THEN CAST(0 AS BIT)
                ELSE NULL -- This will intentionally cause an error later when we try to insert into target_group_memberships
            END AS include
        FROM @target_group_members t
        LEFT OUTER JOIN [jobs_internal].database_credentials c
            ON c.name = t.refresh_credential_name COLLATE SQL_Latin1_General_CP1_CI_AS
    ) AS input_targets
    -- Match input targets' fields with existing targets' fields
    ON existing_targets.target_type = input_targets.target_type
        AND (existing_targets.subscription_id = input_targets.subscription_id
            OR (existing_targets.subscription_id IS NULL AND input_targets.subscription_id IS NULL))
        AND (existing_targets.resource_group_name = input_targets.resource_group_name
            OR (existing_targets.resource_group_name IS NULL AND input_targets.resource_group_name IS NULL))
        AND (existing_targets.server_name = input_targets.server_name
            OR (existing_targets.server_name IS NULL AND input_targets.server_name IS NULL))
        AND (existing_targets.database_name = input_targets.database_name
            OR (existing_targets.database_name IS NULL AND input_targets.database_name IS NULL))
        AND (existing_targets.elastic_pool_name = input_targets.elastic_pool_name
            OR (existing_targets.elastic_pool_name IS NULL AND input_targets.elastic_pool_name IS NULL))
        AND (existing_targets.shard_map_name = input_targets.shard_map_name
            OR (existing_targets.shard_map_name IS NULL AND input_targets.shard_map_name IS NULL))
        AND (existing_targets.refresh_credential_name = input_targets.refresh_credential_name
            OR (existing_targets.refresh_credential_name IS NULL AND input_targets.refresh_credential_name IS NULL))
    WHEN NOT MATCHED BY TARGET THEN
        -- Target doesn't exist. Add it.
        INSERT (
            target_id,
            target_type,
            subscription_id,
            resource_group_name,
            server_name,
            database_name,
            elastic_pool_name,
            shard_map_name,
            refresh_credential_name
        ) VALUES (
            NEWID(),
            target_type,
            subscription_id,
            resource_group_name,
            server_name,
            database_name,
            elastic_pool_name,
            shard_map_name,
            refresh_credential_name
        )
    WHEN MATCHED THEN
        -- Target already exists. Do dummy update so that it's considered 'updated', which will make it show up
        -- in the output clase
        UPDATE SET @WasUpdated = 1
    -- Output the target ids and their membership type for ALL child targets
    -- Note that in MERGE OUTPUT, INSERTED includes rows that were both
    -- NOT MATCHED (and then inserted - giving us the targets that didn't exist yet)
    -- and rows that were MATCHED (and updated - giving us the targets that did already exist).
    OUTPUT INSERTED.target_id AS child_target_id, input_targets.include;
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_add_or_replace_target_group]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [jobs_internal].[sp_add_or_replace_target_group]
    @target_group_name      NVARCHAR(128),
    @target_group_members   NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION

    -- Unpack input json into table
    DECLARE @input_targets [jobs_internal].target_group_members
    INSERT INTO @input_targets
    SELECT
        JSON_VALUE(value, '$.membership_type') AS membership_type,
        JSON_VALUE(value, '$.target_type') AS target_type,
        JSON_VALUE(value, '$.refresh_credential_name') AS refresh_credential_name,
        CAST(JSON_VALUE(value, '$.subscription_id') AS UNIQUEIDENTIFIER) AS subscription_id,
        JSON_VALUE(value, '$.resource_group_name') AS resource_group_name,
        JSON_VALUE(value, '$.server_name') AS server_name,
        JSON_VALUE(value, '$.database_name') AS database_name,
        JSON_VALUE(value, '$.elastic_pool_name') AS elastic_pool_name,
        JSON_VALUE(value, '$.shard_map_name') AS shard_map_name
    FROM OPENJSON(@target_group_members, '$')

    -- Disallowing nested Target Groups
    IF EXISTS(SELECT * FROM @input_targets WHERE target_type = 'TargetGroup')
    BEGIN
        THROW 50000, 'Target groups may not contain other target groups.', 1
    END

    -- Concurrency plan: acquire lock on group_name + target_type in first query

    DECLARE @target_group_id UNIQUEIDENTIFIER
    SET @target_group_id = (
        SELECT target_id
        FROM [jobs_internal].visible_target_groups
        WITH (UPDLOCK, SERIALIZABLE, ROWLOCK)
        WHERE target_group_name = @target_group_name
    )
    IF @target_group_id IS NULL
    BEGIN
        SET @target_group_id = NEWID()
        INSERT INTO [jobs_internal].targets (
            target_id,
            target_type,
            target_group_name
        ) VALUES (
            @target_group_id,
            'TargetGroup',
            @target_group_name
        )
    END

    -- For each target in @input_targets, INSERT it into targets or SELECT it if a matching row exists.
    DECLARE @input_memberships TABLE (
        child_target_id UNIQUEIDENTIFIER PRIMARY KEY,
        include BIT NOT NULL -- NOT NULL to cause error when membership_type string is invalid
    )
    INSERT INTO @input_memberships
    EXEC [jobs_internal].sp_add_or_get_target_group_members @input_targets

    -- Merge TargetGroupMemberships.

    -- Remove memberships that shouldn't exist
    DELETE FROM [jobs_internal].target_group_memberships
    WHERE parent_target_id = @target_group_id
    AND child_target_id NOT IN (
        SELECT child_target_id
        FROM @input_memberships
    )

    -- Add/update memberships that should exist
    MERGE INTO [jobs_internal].target_group_memberships existing_memberships
    USING @input_memberships input_memberships
    ON existing_memberships.parent_target_id = @target_group_id
        AND existing_memberships.child_target_id = input_memberships.child_target_id
    WHEN NOT MATCHED BY TARGET THEN
        -- value in input_memberships that is not in existing_memberships
        INSERT (
            parent_target_id,
            child_target_id,
            include
        ) VALUES (
            @target_group_id,
            input_memberships.child_target_id,
            input_memberships.include
        )
    WHEN MATCHED THEN
        -- value in both sets
        UPDATE SET include = input_memberships.include
    ;

    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_add_or_update_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_add_or_update_job]
    @job_name                           NVARCHAR(128),
    @enabled                            BIT,
    @schedule_interval_type             NVARCHAR(50),
    @schedule_interval_count            INT,
    @schedule_start_time                DATETIME2,
    @schedule_end_time                  DATETIME2,
    @updated                            BIT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRANSACTION
    -- Concurrency plan: acquire lock on Job.Name in first query

    -- Insert into Job, or select existing Job
    -- Not using sp_lock_job because that throws if Job doesn't exist
    DECLARE @job_id UNIQUEIDENTIFIER
    SELECT @job_id = job_id
        FROM [jobs_internal].visible_jobs
        WITH (ROWLOCK, UPDLOCK, SERIALIZABLE)
        WHERE name = @job_name

    IF @job_id IS NULL
    BEGIN
        SET @updated = 0
        EXEC [jobs].sp_add_job
            @job_name = @job_name,
            @enabled = @enabled,
            @schedule_start_time = @schedule_start_time,
            @schedule_end_time = @schedule_end_time,
            @schedule_interval_type = @schedule_interval_type,
            @schedule_interval_count = @schedule_interval_count
    END
    ELSE
    BEGIN
        SET @updated = 1
        EXEC [jobs].sp_update_job
            @job_name = @job_name,
            @enabled = @enabled,
            @schedule_start_time = @schedule_start_time,
            @schedule_end_time = @schedule_end_time,
            @schedule_interval_type = @schedule_interval_type,
            @schedule_interval_count = @schedule_interval_count
    END
    COMMIT TRANSACTION
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_find_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_find_job]
    @job_name                           NVARCHAR(128),
    @job_id                             UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    SELECT @job_id = job_id 
    FROM [jobs_internal].visible_jobs
    WHERE name = @job_name
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_find_jobstep]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_find_jobstep]
    @job_id                             UNIQUEIDENTIFIER,
    @job_version                        INT,
    @step_id                            INT = NULL OUTPUT,
    @step_name                          NVARCHAR(128) = NULL
AS
BEGIN
    DECLARE @error_message NVARCHAR(1000)

    -- job_id must be specified
    IF @job_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('@job_id was not found.');
        THROW 50000, @error_message, 1
    END

    -- job_version must be specified
    IF @job_version IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('@job_version was not found.');
        THROW 50000, @error_message, 1
    END

    -- step_id and step_name cannot both be specified
    IF @step_name IS NOT NULL AND @step_id IS NOT NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('@step_id and @step_name cannot both be specified.');
        THROW 50000, @error_message, 1
    END

    -- If step name is specified, find the step id
    IF @step_name IS NOT NULL
    BEGIN
        SELECT @step_id = step_id
        FROM [jobs_internal].jobsteps
        WHERE job_id = @job_id
        AND job_version_number = @job_version - 1
        AND step_name = @step_name

        -- Verify that we found the step id
        IF @step_id IS NULL
        BEGIN
            SET @error_message = FORMATMESSAGE('Step name ''%s'' was not found', @step_name);
            THROW 50000, @error_message, 1
        END
    END
    -- Step name was not specified, so step id must be specified
    ELSE IF @step_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('@step_id or @step_name (but not both) must be specified.', @step_name);
        THROW 50000, @error_message, 1
    END
    -- if step id is specified, verify that step already exists
    ELSE IF NOT EXISTS (
        SELECT 1
        FROM [jobs_internal].jobsteps
        WHERE job_id = @job_id
        AND job_version_number = @job_version - 1
        AND step_id = @step_id
    )
    BEGIN
        SET @error_message = FORMATMESSAGE('Step ''%i'' was not found', @step_id);
        THROW 50000, @error_message, 1
    END
END
GO
/****** Object:  StoredProcedure [jobs_internal].[sp_lock_job]    Script Date: 9/22/2021 5:44:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [jobs_internal].[sp_lock_job]
    @job_name                           NVARCHAR(128),
    @job_id                             UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @error_message NVARCHAR(1000)
    
    IF @@TRANCOUNT = 0
    BEGIN
        SET @error_message = FORMATMESSAGE('Internal error: cannot lock job entry when there is no transaction.');
        THROW 50000, @error_message, 1
    END

    SELECT @job_id = job_id 
    FROM [jobs_internal].visible_jobs
    WITH (UPDLOCK, SERIALIZABLE, ROWLOCK)
    WHERE name = @job_name

    IF @job_id IS NULL
    BEGIN
        SET @error_message = FORMATMESSAGE('Job ''%s'' was not found', @job_name);
        THROW 50000, @error_message, 1
    END
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_name', @value=N'ElasticDatabaseJobs' , @level0type=N'SCHEMA',@level0name=N'jobs'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_name', @value=N'ElasticDatabaseJobs' , @level0type=N'SCHEMA',@level0name=N'jobs_internal'
GO
EXEC sys.sp_addextendedproperty @name=N'microsoft_database_tools_support', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sysdiagrams'
GO
