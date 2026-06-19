codeunit 50144 "VC TMDB Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        LibraryVC: Codeunit "Library - VC Videoclub";

    [Test]
    procedure GivenDefaultSetup_WhenValidate_ThenSafeDefaultsAreAccepted()
    var
        TMDBSetup: Record "VC TMDB Setup";
        TMDBSetupMgt: Codeunit "VC TMDB Setup Mgt";
    begin
        // [GIVEN] A TMDB setup record is bootstrapped without real secrets.
        LibraryVC.Initialize();
        TMDBSetupMgt.EnsureDefaultSetup(TMDBSetup);

        // [WHEN] The disabled setup is validated.
        TMDBSetupMgt.ValidateSetup(TMDBSetup);

        // [THEN] Safe defaults exist and live integration remains disabled.
        Assert.AreEqual('https://api.themoviedb.org/3', TMDBSetup."Base URL", 'The default base URL should be the TMDB API root.');
        Assert.AreEqual('en-US', TMDBSetup."Language Code", 'The default language should be stable for fake tests.');
        Assert.IsTrue(not TMDBSetup.Enabled, 'Live TMDB integration should be disabled by default.');
    end;

    [Test]
    procedure GivenEnabledSetupWithoutSecret_WhenValidate_ThenError()
    var
        TMDBSetup: Record "VC TMDB Setup";
        TMDBSetupMgt: Codeunit "VC TMDB Setup Mgt";
    begin
        // [GIVEN] TMDB setup is enabled but no credential reference is stored.
        LibraryVC.Initialize();
        TMDBSetupMgt.EnsureDefaultSetup(TMDBSetup);
        TMDBSetup.Enabled := true;

        // [WHEN] The setup is validated.
        asserterror TMDBSetupMgt.ValidateSetup(TMDBSetup);

        // [THEN] A credential-reference error is raised before any live integration can run.
        Assert.ExpectedError('API Key Reference');
    end;

    [Test]
    procedure GivenLocalPayload_WhenImport_ThenMovieGenresActorsCastAndLogAreApplied()
    var
        Actor: Record "VC Actor";
        Genre: Record "VC Genre";
        Item: Record Item;
        MovieCast: Record "VC Movie Cast";
        TMDBImportLog: Record "VC TMDB Import Log";
        TMDBImportMgt: Codeunit "VC TMDB Import Mgt";
        LogEntryNo: Integer;
    begin
        // [GIVEN] A movie item and a local fake TMDB payload exist.
        LibraryVC.Initialize();
        LibraryVC.CreateMovieWithCopies(Item, 2);

        // [WHEN] The payload is imported through the fakeable local mapper path.
        LogEntryNo := TMDBImportMgt.ImportMoviePayload(Item."No.", GetFakeMoviePayload());

        // [THEN] Item fields are enriched from local JSON without a live HTTP call.
        Item.Get(Item."No.");
        Assert.AreEqual('The Matrix', Item.Description, 'The item title should come from the TMDB payload.');
        Assert.AreEqual(603, Item."VC TMDB ID", 'The TMDB ID should be stored on the movie item.');
        Assert.AreEqual(1999, Item."VC Release Year", 'The release year should be parsed from release_date.');
        Assert.AreEqual(136, Item."VC Duration Minutes", 'The runtime should be mapped to duration minutes.');
        Assert.AreEqual('EN', Item."VC Original Language", 'The original language should be normalized to a code value.');
        Assert.IsTrue(Item."VC Poster URL" <> '', 'The poster URL should be derived from the payload poster path.');

        Genre.SetRange("TMDB Genre ID", 28);
        Assert.IsTrue(Genre.FindFirst(), 'The action genre should be created or updated from the payload.');
        Assert.AreEqual(Genre.Code, Item."VC Primary Genre Code", 'The first payload genre should be assigned as primary genre.');

        Genre.SetRange("TMDB Genre ID", 878);
        Assert.IsTrue(Genre.FindFirst(), 'The science fiction genre should be created or updated from the payload.');
        Assert.AreEqual(Genre.Code, Item."VC Secondary Genre Code", 'The second payload genre should be assigned as secondary genre.');

        Actor.SetRange("TMDB Person ID", 6384);
        Assert.IsTrue(Actor.FindFirst(), 'The first cast member should create or update an actor.');
        Assert.AreEqual('Keanu Reeves', Actor.Name, 'The actor name should come from the cast payload.');

        MovieCast.SetRange("Movie Item No.", Item."No.");
        MovieCast.SetRange("Actor No.", Actor."No.");
        Assert.IsTrue(MovieCast.FindFirst(), 'The movie cast should link the imported actor to the movie.');
        Assert.AreEqual('Neo', MovieCast."Character Name", 'The character name should come from the cast payload.');
        Assert.AreEqual(0, MovieCast."Cast Order", 'The cast order should come from the cast payload.');

        TMDBImportLog.Get(LogEntryNo);
        Assert.AreEqual(TMDBImportLog.Status::Success, TMDBImportLog.Status, 'A successful local import should create a success log entry.');
        Assert.AreEqual(Item."No.", TMDBImportLog."Movie Item No.", 'The log should reference the enriched item.');
        Assert.AreEqual(603, TMDBImportLog."TMDB ID", 'The log should store the source TMDB ID.');
    end;

    [Test]
    procedure GivenEmptyPayload_WhenImport_ThenControlledError()
    var
        Item: Record Item;
        TMDBImportMgt: Codeunit "VC TMDB Import Mgt";
    begin
        // [GIVEN] A movie item exists but the fake payload is empty.
        LibraryVC.Initialize();
        LibraryVC.CreateMovieWithCopies(Item, 1);

        // [WHEN] The import is attempted.
        asserterror TMDBImportMgt.ImportMoviePayload(Item."No.", '');

        // [THEN] The mapper blocks the import with a controlled local validation error.
        Assert.ExpectedError('payload is required');
    end;

    [Test]
    procedure GivenLiveClient_WhenCalled_ThenSafeGateBlocksBeforeHttp()
    var
        TMDBClient: Codeunit "VC TMDB Client";
    begin
        // [GIVEN] The default setup keeps live TMDB disabled.
        LibraryVC.Initialize();

        // [WHEN] A live client call is attempted.
        asserterror TMDBClient.GetMovieDetails(603);

        // [THEN] The gate blocks execution before any HTTP implementation is reached.
        Assert.ExpectedError('disabled');
    end;

    local procedure GetFakeMoviePayload(): Text
    begin
        exit('{"id":603,"title":"The Matrix","release_date":"1999-03-31","runtime":136,"overview":"A hacker discovers the nature of reality.","original_language":"en","poster_path":"/matrix.jpg","genres":[{"id":28,"name":"Action"},{"id":878,"name":"Science Fiction"}],"credits":{"cast":[{"id":6384,"name":"Keanu Reeves","character":"Neo","order":0,"credit_id":"credit-neo"},{"id":2975,"name":"Laurence Fishburne","character":"Morpheus","order":1,"credit_id":"credit-morpheus"}]}}');
    end;
}
