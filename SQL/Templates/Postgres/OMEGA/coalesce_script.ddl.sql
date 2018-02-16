-- coalesce_script.ddl

CREATE TABLE coalesce.FSD_Coalesce_DataObjectTemplate
(
	TemplateKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	Source varchar,
	Version varchar,
	TemplateXml varchar
);

CREATE TABLE coalesce.FSD_Coalesce_Entity
(
	EntityKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	task_start_datetime timestamp with time zone,
	task_end_datetime timestamp with time zone,
	Source varchar,
	Version varchar,
	EntityId varchar,
	EntityIdType varchar,
	EntityXml varchar
);

CREATE TABLE coalesce.FSD_Coalesce_Field
(
	FieldKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	PreviousHistoryKey uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	Value varchar,
	DataType varchar,
	InputLanguage varchar,
	ClassificationMarking varchar,
	ModifiedBy varchar
);

CREATE TABLE coalesce.FSD_Coalesce_FieldDefinition
(
	FieldDefinitionKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000'
);

CREATE TABLE coalesce.FSD_Coalesce_FieldHistory
(
	FieldHistoryKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	PreviousHistoryKey uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	Value varchar,
	DataType varchar,
	InputLanguage varchar,
	ClassificationMarking varchar,
	ModifiedBy varchar
);

CREATE TABLE coalesce.FSD_Coalesce_Linkage
(
	LinkageKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	Entity2Key uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	Entity1Key uuid DEFAULT '00000000-0000-0000-0000-000000000000',
	Entity1Name varchar,
	Entity1Source varchar,
	Entity1Version varchar,
	LinkType varchar,
	LinkStatus varchar,
	Entity2Name varchar,
	Entity2Source varchar,
	Entity2Version varchar,
	ClassificationMarking varchar,
	ModifiedBy varchar,
	InputLanguage varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000'
);

CREATE TABLE coalesce.FSD_Coalesce_LinkageSection
(
	LinkageSectionKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000'
);

CREATE TABLE coalesce.FSD_Coalesce_ObjectMap
(
	ParentObjectKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	ParentObjectType varchar,
	ObjectType varchar,
	ObjectKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL
);

CREATE TABLE coalesce.FSD_Coalesce_Record
(
	RecordKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000'
);

CREATE TABLE coalesce.FSD_Coalesce_RecordSet
(
	RecordSetKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000'
);

CREATE TABLE coalesce.FSD_Coalesce_Section
(
	ObjectKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' NOT NULL,
	Name varchar,
	DateCreated timestamp with time zone,
	LastModified timestamp with time zone,
	ParentType varchar,
	ParentKey uuid DEFAULT '00000000-0000-0000-0000-000000000000' 
);

/*---------------------------------------------------------------------------*/
--<<WSDLmessage>>
/*---------------------------------------------------------------------------*/

CREATE TABLE coalesce.FSD_ExternalAuxilliaryDataObject
(
	deformatJobID NOT NULL,
	pedigree NOT NULL,
	creationTime,
	auxilliaryExternalData NOT NULL,
	fileType NOT NULL
);

CREATE TABLE coalesce.FSD_ExternalSupportDataObject
(
	deformatJobID NOT NULL,
	pedigree NOT NULL,
	creationTime,
	auxilliarySupportData NOT NULL,
	fileType NOT NULL
);

CREATE TABLE coalesce.FSD_FileLocationRequest
(
	deformatJobID NOT NULL,
	sizeEstimate NOT NULL,
	fileType NOT NULL
);

--<<WSDLmessage>>
CREATE TABLE coalesce.FSD_HeaderObject
(
	pedigree NOT NULL,
	createDate NOT NULL,
	collectionMediaImageID NOT NULL,
	sensorConfiguration NOT NULL,
	fileType NOT NULL,
	tapeNum NOT NULL,
	devNum NOT NULL,
	amplitudeScaleFactor NOT NULL,
	frame NOT NULL,
	sampleRate NOT NULL,
	startTime NOT NULL,
	endTime NOT NULL,
	numOfChannels NOT NULL,
	channelsPerFrame NOT NULL,
	samplesPerFrame NOT NULL,
	a/dConversionFactor NOT NULL,
	byteOffset NOT NULL,
	wordOffset NOT NULL,
	wordSize NOT NULL,
	channelSpacing NOT NULL,
	auditTrail NOT NULL,
	dataSize NOT NULL,
	fileSize NOT NULL,
	duration NOT NULL,
	headerSize NOT NULL,
	frameSize NOT NULL,
	numOfFrames NOT NULL
);
