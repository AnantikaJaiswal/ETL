CREATE TABLE [dbo].[spotify_top_100](
	[index] [int] not null,
	[track_names] [varchar](50) NULL,
	[track_id] [varchar](30) NULL,
	[track_duration] [float] (50),
	[track_artist] [varchar](25) NULL,
	[track_popularity][int] NULL,
	[album] [varchar](100) NULL,
	[album_artitst] [varchar](30) NULL
) ;

select * from spotify_top_100