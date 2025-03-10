program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse, System.JSON, Horse.Jhonson, System.SysUtils, Horse.Commons;

var
   App: THorse;
   Users: TJsonArray;

begin
   App := THorse.Create();
   App.Port := 9000;
   App.Use(Jhonson);
   Users := TJsonArray.Create;

   App.Get('/ping',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      begin
         Res.Send('pong');
      end);

   App.Get('/users',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      begin
         Res.Send<TJsonArray>(Users);
      end);

   App.Post('/users',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
         User: TJsonObject;
      begin
         User := Req.Body<TJsonObject>.Clone as TJsonObject;
         Users.AddElement(User);
         Res.Send<TJsonAncestor>(User.Clone).Status(201);
      end);

   App.Delete('/users/:id',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      var
        id : Integer;
      begin
        id := Req.Params.Items['ID'].ToInteger;
        Users.Remove(id).Free;
        Res.Send<TJsonAncestor>(Users).Status(THTTPStatus.NoContent); //204

      end);

   App.Listen;
end.


